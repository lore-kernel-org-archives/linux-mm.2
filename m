Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B5CCD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 09:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E75DB6B0005; Tue, 26 May 2026 05:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4C5C6B0088; Tue, 26 May 2026 05:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D628B6B008A; Tue, 26 May 2026 05:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2EC66B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 05:35:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58A0E120197
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:35:57 +0000 (UTC)
X-FDA: 84809064354.13.A8520CD
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id 65F89C0002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:35:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ker9l/5U";
	spf=pass (imf10.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779788155; a=rsa-sha256;
	cv=none;
	b=gNuTWJ35yZ3pq4Yb+DdQ6Ro1qMn+ZbO898AKQxcEtsnijNxpbttSMnYhidR3xUcByy8Afa
	MyKHscpfbw72ammgmmptgl38Bq5wqiR2UEZcLjN8ju49KfIYQuFaIb/Gq+qZjO3cFONfi9
	ppgRR5ZUhosCZAdHyOUEOzdun+TK6Vc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ker9l/5U";
	spf=pass (imf10.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779788155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2bHfAVXmh3q3FWdhM0EExqsSxnDVRJkOcr0NBrLZ8n4=;
	b=hiXnMTRKA4r3/MzJOJ8ngPa033CE6qCZvsaqLK4x/Fn7NvXOneq1Di9JqcJeX6yjXM2evj
	Po6YjQKi2/9dTM1Slj477432lcMe6SUtV7yERlyhwYUnVAAMw8bRvngT/kbff9MTlqdqiJ
	QopVGLSd5pqGdGTnGCkKFKmVJJvzVv8=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-44b330c5cc6so7966629f8f.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 02:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779788154; x=1780392954; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2bHfAVXmh3q3FWdhM0EExqsSxnDVRJkOcr0NBrLZ8n4=;
        b=ker9l/5UqXGQwt3RQ24+ddmI/+IFneEWzIXXXXHJTk33akFHAiIx1lVAnnTMorCxhM
         Pwd3NQf+WQcDGhYH+H8ZdDDWLcpiJoX41UW/PSIFCMgOAuPXrmpP8NGoMLod7Yz/oy+b
         nk5ZhFQAIHjE4AW7NNilYNAethpZSFuA9cOdGHtoT1faQU1mrkTIuYtMZsOT7tzyRB/R
         e3FUNFzjut4bzbWRQni1pLDmawCW1hz8QeA3SZwEZ0Fn60gmEGBSWX7R6LaM3mBF+woZ
         oEhxyX6qkyS80HwtqXGDmIHeiCCnD+KvL3UPtFFZtXRDZ/3/vY21TfK6gHQBfXISzO22
         l4Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779788154; x=1780392954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2bHfAVXmh3q3FWdhM0EExqsSxnDVRJkOcr0NBrLZ8n4=;
        b=RikcBHOtSTt6eQa7fnaYDB0jrT0MKfzoItr+ilyLHoi1YL/PjKO1ku+oJVqT7xuV4G
         F73uvf8dv8awR8BwNAmux8t3FENFmDrw0YEe0DRSGyIB3DwQMm3g/xlG1zwE3qjv/056
         qpy9nKUJ9EwD6sIMOUu9sCGA072tZAI5+bHeeeLdcKnZoIkbJ4tKRfuNP7aHsCaON0pr
         HO494zjXq1oi0wHH6vw7vHAvEeOHJFDFemfzaR7p89E6c4icgDhNSTWNZBecGW3fj4e6
         stM7X9kYYAh8NzOOoezvfELAgS9ysuWkMi0/8MYTtTM2jCXysd1jkSZymJzawSoGB9SV
         TsFA==
X-Forwarded-Encrypted: i=1; AFNElJ/WTXnDEc1pjX8zaYQIoutSK6a6MGOZYMdB1RJxL65lwJZE7obkVVJOg3uJfisDexEwA6xVjwbGug==@kvack.org
X-Gm-Message-State: AOJu0YxnITn+zQVoKsKigBgTej36Xd9108Kvw1BhARkvPD/P2mMQZXYD
	B9qotcLn9MZx8/zal68xca3NlBBsV8DfAvr7bDkdrbBv65bMUWKbQIqN
X-Gm-Gg: Acq92OGtDnoTk092QfY3f0dQAi7x8rTyX2Dx06BvNE+IbQAFldD57fsivvzlQKp/lh3
	h8ZnEeBqFJy00VWlyFyU6pI0pcxgRVSKStTwm0HBW6MQ+oFUb3f/LmoVUmO7RjOxOIJgE2ZDsY/
	q4tB4Tb6LfHeUDm+M7J648TKroIIP5oW+KmpDvWwLLDqCH/9Od0XA3FZ2Y5QoR22uK8h1SkVfMG
	hW11/WdlPccCkfDAtSF+JhtH/WPd4LZdseNEMEF2INkxznP8UEhlbIqJ4tzwk++km/YRmSqUJep
	pZBZbIkT0LG5pR1SveiYjMs+IVbGppztOa4VKhKx05i5zK8/CGC+B50zHNqXnfZ/qcpv41nzQYP
	xpUX/yo289DLgxtQLVzE18DEdYzdIOEJNHqsSwxvrTuosqIbrIqSkzzT90OJYbhPRYcNyeJ+3r3
	J0qxN+LyJwJi8YvOrmjXgyz3F9+ae89ICYHSmHMoA697ibV5TsAYPYYk0g7Xw5vX9qHLcmmDqZ/
	g0=
X-Received: by 2002:a05:6000:4b07:b0:43c:cf25:f29a with SMTP id ffacd0b85a97d-45eb3689049mr28173297f8f.8.1779788153530;
        Tue, 26 May 2026 02:35:53 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d64eb1sm38023448f8f.32.2026.05.26.02.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 02:35:53 -0700 (PDT)
Date: Tue, 26 May 2026 10:35:51 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker
 <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Ryusuke
 Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko
 <slava@dubeyko.com>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker
 <anna@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, Jeff Layton
 <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Olga Kornievskaia
 <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey
 <tom@talpey.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, Theodore
 Ts'o <tytso@mit.edu>, Miklos Szeredi <miklos@szeredi.hu>, Andreas Hindborg
 <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, Kees Cook
 <kees@kernel.org>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org,
 linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <20260526103551.0a05ec07@pumpkin>
In-Reply-To: <ahSNFmwAA17pMy6o@casper.infradead.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
	<20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
	<2omm5gmnv2khshoxkrag5rusd3qzrsqyjgsef2syxgryrtg6vq@ao7oabqwebgo>
	<20260525182134.04045610@pumpkin>
	<ahSNFmwAA17pMy6o@casper.infradead.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 65F89C0002
X-Rspamd-Server: rspam03
X-Stat-Signature: wghx3wmxyj7zfg4qtnxzigkwzqn9jmof
X-HE-Tag: 1779788155-213737
X-HE-Meta: U2FsdGVkX1+QuyVNpfub5pkIh1+7+bGESdCg1lTXbAHTQriiznSrgJlEncUszfhepja+vofzWtli7HVblyvssEsUlW/898uI8KSS4+D/wTKI8KwURsaJohd/ttjFZntaSu7lv3z3efrRqyRNCQoysATeY4/JwWgxE5VqPuqKE6/bOpAlgOZypMGSp2mjtRccMXeaIg9eOaNpkf2JR7jlDbUxLQP0N5COHbpgVmDDm9dVxNnK7owVpN0gLdIMN/p2MZyG0SfJBGx554QcoUTB1Gvr13Hmtsko8z6c/SLIWK0Ov7aDoZExOuSdYhP/SIs/meh6jrK3M2i6mnS85/MgSegMAeK7k5ErxRWIJUogrcNYsA+dw7paZyApr990p2r8AXLZdlFby5vQapLHS4mssQ1zWRs0pjl8ul76wiiShYLjycGtIpvAdbO4u3SZeoxu7wYBX41jrYkJYURwzsaPc6wRMliuAKt710AANg0aKLWxiBrfTz+DpgSiwbJj7Y2YcKXF1qkk7TT75C9wVSiHACzGMKB9iEVkfDQ85nNeRmRP0Z11y1367gL4J+ohXWFuWimY5WAZIyBCTAzWJgnJyw93Shwlfgiiy4C5Tk44H35EX8XpLD5l/VpNDZuHmsTzLt8JNQozU7LBoN4VJx1eHLMlXUwo9eouhSEmepilY3z9Tl+VYA6LUkiegTXxb3vICJ/hxIJKCX9/RGZKNkcdF6txX+KN7m0zyKusD3f579ebna9idupZse+jGiiFP8g6fp1776dA3e/mvOuF09qZo8UOnWTjqRkXHvoSbyaJpq7mSyEfHrbn6Z6sVEPt0isOrnKIGuwKg0F/cqbYQ7ufKCv8HUpladFuL+6zSEPzJBAXKpx9F47CUHr+uTObGCgLPjvbkWSCdaWlRATwtF6XvicjTpXqc/7rfe2GuPPGutjo+oa8SaZF0d8jn57GYtt/fEN0qa5mO35kLu9pR8w
 wLeADUwe
 mExXmIUob2FuslYfe3G+/+1SrC7MulEAfEpURHlvcfTlfcgkvA0LVhjKJg2g9Crezuf6cmVrnYlLAEdKCNcnzZ/tU/O1lFtPjwqx3zyEYVZ5zrg6yP8vggzm8EdM+add6NlzOaQhU3znmmaCiTtusMK2KaKqkGNbL2C09X5RKpYZujoSm8BFOojtUE/5QzKuUd4werDNP5MA2pvOFAjB2susiPwklkm/6q1/A4QVCfnezNq03Asrm20ZbvvRyqXEYfHkgD+lKONeWNMU+LhasaxEYYrIYmM1Wj1AgWYggtQh3yg9zrNYCJa5ouVI/v8NAGcga0PBy1monlCI9LlrRWIRE7KDjIZXiJPG1POSNsozOp/n3xJx6EoU0FEpF+hGdk7mIkqQay7uHh5dvLq3CDBQeWJTbtISgefG+WZWOb9L2F5X3mYKuC6nuI4HZfdE4lbQ2DAHQEvoq0m/DZAiikH4GwsJyRRO2LDlCI1F6AiZQbD/R7Utf4hDfXG3YVe4WnDk72q8nGg/VwNo4KOFAJY5KOPqlYQWhNJNJXVqg/el+Z/hx3G0iIbatEbB/LxMIuEWiHAOjB4h28TfIvxTQGSIzdX2Jq53/XPPC8aib5gZnPL4RIdXqdJ3O6TSAkZrrAZRW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 18:55:34 +0100
Matthew Wilcox <willy@infradead.org> wrote:

> On Mon, May 25, 2026 at 06:21:34PM +0100, David Laight wrote:
> > Would kvalloc() be more appropriate here?  
> 
> no
> 
> > Does __get_free_pages() return physically contiguous memory?  
> 
> yes
> 

Thankyou

