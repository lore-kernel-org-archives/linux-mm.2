Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31572EDB7D0
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 21:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69B2C6B0088; Tue,  7 Apr 2026 17:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64C046B0089; Tue,  7 Apr 2026 17:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561406B008A; Tue,  7 Apr 2026 17:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 465A66B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:21:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CAB2B1B8D7D
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 21:21:46 +0000 (UTC)
X-FDA: 84633031812.06.EE0BCF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id F0E2080008
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 21:21:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="lMRg/l/X";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775596905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A5JGN8nXOzZq/vZE+77aBOsE9Tq+2f7GYXCovF2Kw3Q=;
	b=7/v1hYb7fkEMfCtn3i66UNhEDWTxn0w7/tPHctqZB3oL/v+C6VmikCGsbfZH97/IyKimGV
	F+TzhCUgivxlr2m0exgJY3pwOx+PgbCnL/wZ9wJYG3zcKqJZ2jtbSXCxvwr4vaeB+9ZS9M
	adRde2aX6lq+cIy71PAEiVOuh35XDP0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="lMRg/l/X";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775596905; a=rsa-sha256;
	cv=none;
	b=4Lhkd6Se8t4XJTPj1azqqhBvifqmFhti6TCtNWLtBIBbV0+bdc0hg3lUr8cOoTnWch7MqG
	BymR00B+bX0GObuw+RbGoj4IvdaO1h9pgkYS1Al6mXnBXyTGiBxSQLJ0iMhqKFI9xOp7Uq
	tpXHSbEW7lu14DkkikJWtEmGfSh8UNQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C5AB0416B0;
	Tue,  7 Apr 2026 21:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B7FC116C6;
	Tue,  7 Apr 2026 21:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775596903;
	bh=flRlnuqB+MkUrPTOekHdwaceWpK62RG0kNmM4HTgjUk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lMRg/l/X13Y/iSRcAsT5Zn/Sofzb4N6k2MmNKq+nd7Ut6VdDFbMXMeGxT58R0LG8o
	 o8fhkG9PzUzRy/PvjOJspXVchGGJCKj8uUD7oCmXpuMeg2Rl/P6xUYGBJtHF0UwnrR
	 Xi4S5YT1SorcgV+cGeps/so/PTTNxLb2XUqf4kEk=
Date: Tue, 7 Apr 2026 14:21:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, xu.xin16@zte.com.cn, david@kernel.org,
 chengming.zhou@linux.dev, wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn,
 Michel Lespinasse <michel@lespinasse.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a
 suitable address range
Message-Id: <20260407142142.cd093ccafe62eaaadb5cf11c@linux-foundation.org>
In-Reply-To: <adTRPwNMzogT1OYO@lucifer>
References: <20260212193045556CbzCX8p9gDu73tQ2nvHEI@zte.com.cn>
	<02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com>
	<20260405140132.3a518740c6c1d68843f44aaf@linux-foundation.org>
	<adTRPwNMzogT1OYO@lucifer>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F0E2080008
X-Stat-Signature: 4i5b94mcf48wnrruszxocamya4knw8on
X-Rspam-User: 
X-HE-Tag: 1775596904-100978
X-HE-Meta: U2FsdGVkX1/mSdfV3irxD01AaqVCaIX2rsmy4LBrkaHaWTCbRD5zGPJRwlMES29Q/rSEMgmPQB23R3YREgxrxSziuuI7Q/fiC4QBy3nV/cpBGZTZVFa9+BDoAXd1vu3KdTuv3pCAenhalH6/01aAI4ArMc04tcWquDVPB8fZmJpHXkJDwi3iuuA28hrEcqQsue9iBDMylLF21fYGi0DskWkVuQxqVWMM3GAHmJGmhaJUMJAWZ9/2GYzd3n2HwelzbHr6nDxk+nMe2y9ZFzI6sELwGCELwRymjI6HC0Mue1c/QKlX9jR0QjPQQEtU1zL9pWI77FNh816bnBFtmcAL73p2IVO25nbB5h3dDcRPefP6nGKjlydc1sFUtA6Kh2igMQXGclW4ZKJvGUFq0IhDyU4ip5+hbuxS8BPQPbedweKyol/eRR7rY1N6twcdoJp8+ZSfdkzknjr38ABeQ308MBFhQrP7FmaV/mXyaqZcxlb3ac/07CHJ4RIUMR4Qr/yyZCseHpoWkrGnP9ai6ALQqUJNqz3kHYHJMjG2LXqke8b69FonZuyV0EG4gx2rA4fADY86blH10dKB6/CDFxZ/eVL0s1H+kSxy5XgPBUN0ZupDus/1dM4JMvpzjbnzjazI5V2+Bx7ZVoKAJ25/6j5vbUS4cOLzBVkDY3VT2/w/YaGBcITlK4aWMHY/lmqduHrPSLmasVn1QhXAX6nPngq4yoBmAfusIY0oRTAdmGiUxLxSbhW8FHZ6pqMSqtYhx4T2y0oqunrQ4pvWw7po/XikCXti5+m2vh+iD7F30Oh98bo3xlFXu3gQFLgGp+uK79IyWjc/Zx9mfYOCO/SnHPsfgk+F8ueTsO+vqbDj8s9MEUbinX1jZmzfMw2jIxmZoNN1BPky/NCoZBWg8dOm73Suk+vwaJ0oKJqAo0pncs4v3F0zYXQBkOiN+jxXtLoh76aQPyGl4BD6Vv7gCJSoEZw
 azMy5izs
 Wze1LkJUhsKCsL7SgGn2vjVKiWmvxEx86A+OH+vviPRHaTe1jNE5KnZcxDK+6x+WxKDNL/V9lsPGzGyqKdIeLIn00bjjyulmlb++TYWBzTmS0T4GKxlSGxe3NA0GYryF4JlFxLzsO6zq92frQbErkmywWceoBRYI1xqrBrikXDL7dGGuF6ixwuUXSw5bM36QSciFfov9tJGNM7w1SMle6E/yyNO610Lesbvw3+dQ6WhzXeEsjQKlJrWc6hpbpzVxqhSXtCRQVOwXM5Ru2XtfrKseelFFgD4+S8YA33/etKbmfBUD3naAlw7rQTflOvoVPvViUng7DSSuEVucI0efSt+o2KTwQwnpYH3rcvVhZsMpUeGTGGk7/xbAHmkc+uITUlHqJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Apr 2026 10:43:12 +0100 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> > Thanks, Hugh.   Administreevia:
> >
> > I've removed this patch from the mm-stable branch and I reworked its
> > [1/2] "ksm: initialize the addr only once in rmap_walk_ksm" to be
> > presented as a singleton patch.
> >
> > For now I've restaged this patch ("ksm: optimize rmap_walk_ksm by
> > passing a suitable address range") at the tail of the mm-unstable
> > branch and I'll enter wait-and-see mode.
> >
> 
> Given we're at -rc7 now, I think we should delay this patch until 7.2, unless
> I'm much mistaken wrt Hugh's concerns.
> 
> I'm concerned this is a subtle way of breaking things so we really want to be
> confident.
> 
> We should also bundle up the test at
> https://lore.kernel.org/all/20260407140805858ViqJKFhfmYSfq0FynsaEY@zte.com.cn/
> with this patch (should we find it's ok) as a separate series.
> 
> Really overall I think safest to yank until 7.2 honestly.

OK.  But let's not lose sight of those potential efficiency gains:

         Time_ms      Nr_iteration_total    Skip_addr_out_of_range   Skip_mm_mismatch
Before:  228.65       22169                 22168                    0
After :   0.396        3                     0                       2


