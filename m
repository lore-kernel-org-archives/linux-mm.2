Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD757FF885D
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 00:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBE866B0005; Sun, 26 Apr 2026 20:01:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D95F96B0088; Sun, 26 Apr 2026 20:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD3816B008A; Sun, 26 Apr 2026 20:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD0A76B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:01:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3DD2FC2371
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 00:01:48 +0000 (UTC)
X-FDA: 84702382296.02.E945D2B
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id 54509A0017
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 00:01:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K0eigLgp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777248106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=m+OcXCtyDOvxnxJBKahNiKM8NtlieJ6bMOjObt0m7n8=;
	b=n9IGAJseI3OSSW3NszBwOO/irOFQGoXk4SRqbczo0QoiXTw6I0Qwj1wwfbElYrCCZZZ4oN
	60ul3omb2Q3p1cnyI3HHRflR9QgVu7yEz2MS4R2jiJjj2bfNGH+N5TkgX3ey/+f4ZwUM4X
	352lpsl2ehoHS4jELA1yPajP3PQ6m7E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777248106; a=rsa-sha256;
	cv=none;
	b=njdOKBGnSghiMCAK1M7Zk/E9h4YZ4TJfCDFQxxj41TOiFWrcmP1WL9GbPaIVH1dGgOz87J
	05k438mnP0i9/+k4vjvL+IyJDEHAPG1t7PZZbBY9Fsa1vA3ja1SSwvX3S3DXu8m7Htuowk
	kBRSrJgzsWP/l8TmuLa/QqWJXaTmOI0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K0eigLgp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c7b9f54d3deso2851502a12.1
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777248105; x=1777852905; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=m+OcXCtyDOvxnxJBKahNiKM8NtlieJ6bMOjObt0m7n8=;
        b=K0eigLgpBtCpbCtOR3CLoud19ycAcVx735R+swnwjT2oKetGkydFVG2tFL9PxU2UGD
         Nz1+OtYginjN+tTPx7rTs0jfT2+iDA+1TeI1oNxsww0SfIs+eDlaJQIkEVNdAdFBl9U+
         rNT+AuQVFm7Ojv/OZ6cesXFmiaTEO6lTaYtU5MT2PvVOvuKICuq0h1P9dEr4Dng0cdIj
         l/6pnEKD9Z7Gyg/gAIm7Dz2NfDbTxyr2e4gQE6AWPg9WTr4gYTpXjFHH4xeL1BNOXgPp
         SLz/NLzVK2UGVYqngXU8Vx93+LubvouuO/3wi+WmKQ+3k00TwMDPtMgjxaK34BDZeScY
         jEZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777248105; x=1777852905;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m+OcXCtyDOvxnxJBKahNiKM8NtlieJ6bMOjObt0m7n8=;
        b=qgcnjnIIg/qT5r6AWywoZhix/P0j/mFvZG1lw2f7XpqWKKjRjo7cWfsBrSn83qg/02
         qqb8/FqgH2YAAa+mGMtMVAEqV2w5eRQloWj0EfkTTBZH1fVLi4onP3eqB2yInfbvsDji
         ASzQWMBF4LvOrJzUhMn5F1ldt2qy9vihqnCaSvt3zECIic7dOC0Sd/q26DVe9j1dmsLb
         vU0StCbGf++8brSy3OgB67veB1jrc8a3WAM+8Cef16zZJvh+db2uZ8C9iiGXGRmOgliF
         fe+fP/i5Tl0mPzzTmNfJCxRPVjTaecs6HwRYu5JOvlHgMkc8pSenz/x7yGlDRkHxY9md
         nWZQ==
X-Forwarded-Encrypted: i=1; AFNElJ8RpgWoS/KswJF2Da9ZGzrLCM8tJuyFHMhBUrD/wtgKVHrBxE1/0xORVEdyaaKfO2kcOAb5etWDLQ==@kvack.org
X-Gm-Message-State: AOJu0YyJzUhStVIKyxdw/1vq78elIfPZF655tXzGzhY03tv1nM5soC1H
	0gpIh/UBklEV4uBqggljWDxVViw6zP+D/pZGX1xt3//zdd+mbsveUdZK
X-Gm-Gg: AeBDietLAMlMad7JzWKrfW+NfK61Pkv9Ml0cGTPHiGAjCUfzj7PCanjrdam1l3IBkNx
	V+GCNut5FnbsKnjhRpXwkpw9/D0OTHLCoQv9cBacRWr619K3z4Mhz4Yu1qTIuaSsLGO0CpJxoy4
	9/61s4ZcNhf/WvgeSfp8T6uZMF9EyI4gOsaZaAmfO8cIIQ+la7Hv1nJivdXITNbzOiaFmh0ETq8
	GlYNBi0LReGluVl8vdaYdmIeVPtJzszDPK2v0Ck7VvBI68PrioL8uZ3pq2A5mRhpg4trzwE8ZXz
	9uDFu9/qKXfNpVsVomnelEx30XgHcxX0Bkf84RG7H3l0KZN0OxupsUavduuZmm+BstcFw76ZgTt
	1jS7B3RNSgVl+vtuylOE4MS1FffXZQxCKmBO4jbaJ/P4EIVdLdcpOjhs/e9/Rleosiew9UfJjDa
	WeC8vXDV7dbvTmAgWKutrpqqjooBZr7rQOGOBEZqoKjmA=
X-Received: by 2002:a05:6a20:1588:b0:3a2:d629:16b3 with SMTP id adf61e73a8af0-3a2d6291cbemr35605566637.34.1777248104974;
        Sun, 26 Apr 2026 17:01:44 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8e982fd3sm37959290b3a.10.2026.04.26.17.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 17:01:44 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Jeff Layton <jlayton@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Chuck Lever <chuck.lever@oracle.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, Zorro Lang <zlang@kernel.org>
Subject: Re: [PATCH v3 3/4] testing: add nfsd-io-bench NFS server benchmark suite
In-Reply-To: <a1e784d7006fe5d4331d41a0638be117ac67fb21.camel@kernel.org>
Date: Mon, 27 Apr 2026 05:24:15 +0530
Message-ID: <mryps2fs.ritesh.list@gmail.com>
References: <20260426-dontcache-v3-0-79eb37da9547@kernel.org> <20260426-dontcache-v3-3-79eb37da9547@kernel.org> <20260426053455.4c06140446976964e6fbb8ab@linux-foundation.org> <a1e784d7006fe5d4331d41a0638be117ac67fb21.camel@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 54509A0017
X-Stat-Signature: jsk3qhgxhyht4q4o3urkmzbju5oy6aw3
X-Rspam-User: 
X-HE-Tag: 1777248106-107397
X-HE-Meta: U2FsdGVkX18samoEyxXQdt0xBQU3Wq8HfhO8KeG7aQLG0AyB+bQlhWMMcKlV+T0bjm2PcseC7fQFdYALtZAR7p/IdPFFe4dxKPa4hRolDLGwqUeelhMLTra+6S2GRIun4jjJdZCUGoY1Rcep3h6KLrI50TvswI4h0UGnNF7S1k1wbv6984rV37IqkOy5SGCRgVIqWOolyTLZihJ1lpMKoBZ0rJLEZaSkBrbmdWvSd8WetVU7szaL2YIYqW1InKnP7ngK/QWxeD1/CKU5/SfiyeTiGlcAN16C9vyvdZ1HQ/n4a+bzoSQl+hFoWEiCO5X9iYXWjFBjewi0/uHxVouoG5ouh7Fyd7zEzqZLtVNQicswqUb6E3iDXpVpL501MjmXCgg/ItbZ6E4WwcUctXoWzE6izdcGLaYMJFHfdaIcubm8DlS4FRca9vIrOysVyxFBwGPVpcVilSGb6kiOyqrZ9Wc34y/tJOXvLA93YYfyRCe6TH8x34e9emDKCvfTQRJnd6steWunhdwkgX7iAm8lwBI1gARMbJ6FyY4chbhk8LUoJymr0wfegtmJUwMu2Y1cfQZkOQ53MRroVxxf9qbpHgArJRY7cFq8N7iE3H8BNb/r1jVnQPY6AhyEnUOgH2dIpDOpruYN0IZkaJou4ph2HP5UDo8PjmUVueONT0UxUo5xGTF4oKeic+AN4/2ujqSPu70AO/XRLzKlzJkHJGuF2CHyOE/VkvLo6JOQrD6pzCaSwrNoFVTGvMkV4o69k9sGKxYlO/b6kZdJIsTsTPbU0f76pVSzuzWyQM3pEDoRAJzRKIGJDP77U2yvWwVVc1MhfIhEEe4t5beXnanEfwVuXVQAEGrTod3SJHLbICDPVKLSeUNM/uTRJCteRG6L4OC7kDY/bYdOnWb5+SvVIZY/XRfUpQqKRJlZ4DfEQ7DHhQMs1j1xiuvDqhxkeqSeLMqWEDYHQGWxu5OA91s0n+c
 7sx1HeOP
 v1oPAxvcgAgygN9iFGVeHQuAwm0kV3S6WS0KfGnO76tnSSmlHGNXjI5Fb6L1DgWuC1sIBftUqsB1t42mCmSxFWFbAd6PCXH9nsiSZBsuwVfNtdJx40Zd+tJ/B+nsi2u1YtgFuEOVUC8BzCdirJ/nSXIYMd8nLzDP6sPzmfHdc0OCT2lb59iFcrU94XVHbRPM6Q18IbyhFvUEXop58xImneTDP6ZfTqSj/B54tQA0bzycNoD8fmDUnKJG4dp/GME+sekhRKnlBtmvYwuwnvqMro3bu6bPyJeHXj6XTQY8zapIbauD+ZEC6a2RQitmSLVi3rFNSoPi6EIIXLpO2OBUsTPjV1fdP9Fhigv85RQSBT3p9J4Fwlybn4ly8BbEQOqoHByUonvQtsfqwCLE1uhC6M5GiZUQQ0ov+5swXd8OBMXkBAhWFeLUq843zBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jeff Layton <jlayton@kernel.org> writes:

> On Sun, 2026-04-26 at 05:34 -0700, Andrew Morton wrote:
>> So how are we to maintain this?

Maybe in xfstests? It has tests/perf/, but that just have 1 test.
Maybe others can tell whether it make sense to maintain such fio based
performance benchmarking scripts in there.

-ritesh

