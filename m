Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 763A9CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 13:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2CA28E013E; Tue,  4 Nov 2025 08:30:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04D08E0124; Tue,  4 Nov 2025 08:30:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41DD8E013E; Tue,  4 Nov 2025 08:30:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B67908E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:30:30 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 752CB12BF52
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 13:30:30 +0000 (UTC)
X-FDA: 84073009020.16.E4C2DB4
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6655B14000B
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 13:30:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AgZJvidd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762263028;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ehk1W8qCU8NEtx0V4guaC2b2vH/ys/H+vyYGxeFZ0m0=;
	b=HLeUztgnooPRokidh0O1ASfHX2cpgawexqIEPtUlz4dmklwqZWd9XhCx2+z1uq6wwv9JST
	tTXJSx6XzzROClV9vNkL7VX1RlXG0q/WuHBzQ9fzbMWAOEk3tZ8Dpc1WSJfzAgKJYvc+3O
	qxB/NpCJcwvwLoStUsCh2ni/ll03Goc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762263028; a=rsa-sha256;
	cv=none;
	b=DxUayN/6qmKOZKxP0IHdSuOyZ51p+1w1K8hbc8Y2HyKN3YRYqew3x3IB+UPHq+QE6k3w/7
	XROjOn8zXB/QDv3R4eukWmn/1i8OG4jih1Y0aeMlYAGVEexxlihFkq5P8ENYNwovcq0mrR
	/xXta2eGe6TwrHEaONoODhxwa99+v8Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AgZJvidd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-63c489f1e6cso9933461a12.1
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 05:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762263027; x=1762867827; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ehk1W8qCU8NEtx0V4guaC2b2vH/ys/H+vyYGxeFZ0m0=;
        b=AgZJvidd2zh8IhrZAk1vmAMPcL41Tk1gBwy1ov+tuUL2Y/IRlfFFadn0aUBnOocXdl
         KhSW4Bw3HApoPc0WTwstCbMD1ICoS5cFDBult0/z/uwrS0JVt5Wa/X5uz9CY4aqEDzoF
         y3emxwPlR3HJDlTr8KYNvCsx+8iAtEqdPZGCe16kEJLGAMnSQcAwFxQjsCPFvOwG/NGi
         w13b2Us/Vv78PtixMmSGEC0zZe+7TfN4QSuv5dC01L8jGlFdt6i9auCFMauNNgro/C7w
         3oA5FM1P3dywzDZ7SDCyR+jeHCB51QDLHseA/KQUMnARd6FdUwlFPJ1RiX6CmTaYEUvv
         hv/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762263027; x=1762867827;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ehk1W8qCU8NEtx0V4guaC2b2vH/ys/H+vyYGxeFZ0m0=;
        b=DUlx6DuxUZ/NOoVKvwCMT3ZevnyF5ei+p3UmjdxT0LJGtGrYjmGPaFA5ILCBdAaG8q
         dXwVl/un4dj3fymHI+7HhweKhW+NDsB74alnL2YSh7taxTqSH062IICYXd3eV5CWnL+7
         KEn0ILTFHxOKuhS9yPfGYR94AWXhc50KHRFpq8uD6BDVIroEQtGGkRDk36eQC7yhg4Zb
         lZIRDUxIv3lj2eYFof+uGCJErTn8Tc2kPlB7pRD8+6ylhUyAVuCHas1c/RgF+pbAj54K
         t9bZDEf9C40TqbgssooQqp9Bjn71E6nUw977i6B3C0Ncv18ov/FxZFwyx/haGpsWQg5i
         9Fbw==
X-Forwarded-Encrypted: i=1; AJvYcCUek4wSFhdByHDov76YiEyh7k/u20eX/pJJxWkSweoVMBMZtg74ARorpOOhci8Z6alPmJm6Azbj5w==@kvack.org
X-Gm-Message-State: AOJu0Yyo4k+Tmr9pJe95BJ2jTnN20fAfd5xwXg56aIgea2NVwlNVqgSV
	wkYkWFX6aIlbWSHbX4tBcKrdaz4SasAyt6uKN5M2R9vxnC6bkLZTWpvT
X-Gm-Gg: ASbGncux94R1Q48KR6U5AnEYVISUYgY5RfIkPInlLMS/aiLyc4KkJj/frxwRSY7II3s
	mylEti/JDQ0v1+LkVSruE4GnIyXWaIqxv/x9phQbwo5roN+4NA4MXh/IEaTsIcC6f/8gwQQzT1r
	u5AfAa7J7Ym0dtOhryA/Yi8WkYoMqlUyuL62OzSPi7RpZrNWNBSSDuIYKyEy3LPnmn3xvuGP2fS
	YgiwjYvXNM3YW23+jjp308HliHKegttgN7quIEZJt51CNYRLAp/M/2VytP2CtQZQ5u0fEsuYbYm
	Nj+vwf6pqRlf6qgZojAEK2tQv9BDAIOSUOg8IBH4qIAIAZ3BTAiQAsGbiQoaPM26ReIJ2Wc2iS1
	xtN721erktXJOM3sDbyKtsGi2V0ubnbMEzTRSUea7GIkWDPUGvgcUC6eqoDT5NdspZKQWx+y9nB
	M=
X-Google-Smtp-Source: AGHT+IGgxpgN6rQpqHAcGEquLC/J+Uuvzir3h+PkU5xXIMsg5qUjBAX7sM9t3TY8P84VQfm+UUoPHA==
X-Received: by 2002:a05:6402:22d7:b0:640:94c3:60fc with SMTP id 4fb4d7f45d1cf-640e59e5275mr2011084a12.14.1762263026506;
        Tue, 04 Nov 2025 05:30:26 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-640e6a7f1besm2103532a12.33.2025.11.04.05.30.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Nov 2025 05:30:26 -0800 (PST)
Date: Tue, 4 Nov 2025 13:30:25 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/huge_memory: introduce
 __split_folio_and_update_stats() to consolidate split task
Message-ID: <20251104133025.arl56nr6f5hmzhtc@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251101002927.2610-1-richard.weiyang@gmail.com>
 <20251101002927.2610-2-richard.weiyang@gmail.com>
 <b2a1ef9a-9822-49c8-85e6-43b19bc8bdd7@kernel.org>
 <20251103233728.b5kmsit3vcqpmr6w@master>
 <de9943ab-1fd1-4a1e-940a-a3ea86f544db@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de9943ab-1fd1-4a1e-940a-a3ea86f544db@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: xbbau9ytufjfsyjb4rkhjcpf17bkh1dx
X-Rspam-User: 
X-Rspamd-Queue-Id: 6655B14000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1762263028-303622
X-HE-Meta: U2FsdGVkX1+ZbU/4NEpt3B+XWzetx3C4LE7BpeeL97vULTVqpHRgxsNpkxX9f/L25kZLHDFfZOM24Rir3DyacvIt7HB5u9Ccp45jn+2AWRN9cjsFCHFskC+ftArEHJ0shJsPAD/zysgGYCXPL3w9ohRUxKXRWsyeCUBrPrzINptEtG5A9KoDkOm/NjtL7SA0RWcRKDHsnNUuCkTvzRo8pAD+KfQGYjmXwFA3bFaCNtHTToDsJI/d1b/jU76EKBEe2TSnZzMOt36f2ljlJVw1Xf/zoMWa5jPku1tlrAKMq1cHnrHe516aTyGGrYtiLOvnJXrfWd/otmMvSRaizZhNd7dwmju4Zx1S2QeIPB0gmmY14/imJLEJJryebO2gJ3YErFzkpWi95gMb1U+os+784QXg3ZNUJWuqr2RwA6v6Ok28LBFxvAkkzW9YPVP8S+6NMba6htJgvVDqdrhrXqqbBHPr32iOFQ2kdB4YrGVsSJp88jmBm/9NQ/VlqN0HQu6xm/G5CQyGz4fNNXWvtWmvqmr+OTFVfAhhsQINs0V6hdZ0YrMutGdpiwoYKLC5pi1y5ymSKK7lYCh4UcdPlhpYv1DLnNFbI3F1HWP9VB5ZCpVB4AycDdZFxue2eqyXVnboGABXroU22n+xYAw0wxIftLWPFbke6maHwxvWnu4/GfA54zMpfslpV6Btcek1ZKqYRbMG3Tbx00PoKscpWG2bpFYcuAezn50c53CRSValBIcT6FsO8olWwR9Zxn3KO1xUIzNndn+4N5RvmgfbFXHlqZsmVNxaljxj5BgfOc4g0JSwKQOoN1Z9p1kl3NylQDqZxikjJNwrRhljAveJK/xe1ZSRgb0SR7wquoS6clXpeCGNkmgQcNp93uLrzdSL3S7H9stjHbX92ti/FVBoRU4H2/XalHdJh9Wm79se0Ig7g//SGZG9hv+AEW66HS4vXuaeJaPJidCdENjxo5BBLle
 2js661XX
 LM2frBVPQD7XOFiy2D94oLqJtvrfJWNVVrF0d45nGpB8seHcqvPmUlOjeG5XBG05o9/IE3qiTyJZ+KKrBs3cmW5gg+UnACD3b3OtEVpaNlK5ia29sFf+BbfMY4wH87ZgPyxlnPlvKsRMfwdymhpZmxabf1Nfj54N/Wubv/k2Ik4C1ZAZ8RpX7uE50LE/ij9OMy1r//3Au8hOpDefWMTPRnD8iM+OYWBUmqy7k3YLtF/q4DMeO4kikzrKJiLbQVN/LkInaTDo7HrabpdwZV35X5muixuxiYEihRM6k+eTBABDroYhQUwL1pZ+ad57iAVBOh7e4oyHtjwHJ4QruHPmJ695cMh2kM/bBYR1gVtZkZ3vv4qB4V4qvQ10Db63O+H7nSul+xVAORFVv1a75CoUgAFMPNWsGPWnNePs1czRWNyZwM8y//Ky5gNCDKgDlKtONlNd4yJKl8DzpLNxwwqRnfsR8o4tov8s7hkJqh7gFSmsqz04zF52eAAv6DQuT5EkrF3B/JdH5MfWqa4njlF0EyhivrRq/DFHHjgHmbQrf4SJzPOcKeMgHGquXswWnNfIH01oEEFNvCQv3Zv54dwfYVVYja+qYiUhAd1p36iBUO5JMKkrPeOkXEzKmmZyaJW9TaeRya6ySGjGIeMspV0oS/LlgdjZgWbYVES0mMTHvTuutAGOrVpmbLzO13EBlPreFZHzr0ufrWYyyyk5qrm0yDgEwRaMpezu4SvT/UUZVOV7QTM1dUDOs3/HtvqOpuf8evwljYlYJeVDaPe2TdpWFOLeywMZvCYI2hY0x3weK4ZRGCrzkmJH8ArXD9S4AEYu8LzI1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 04, 2025 at 11:33:43AM +0100, David Hildenbrand (Red Hat) wrote:
>On 04.11.25 00:37, Wei Yang wrote:
>> On Mon, Nov 03, 2025 at 05:20:02PM +0100, David Hildenbrand (Red Hat) wrote:
>> > On 01.11.25 01:29, Wei Yang wrote:
>> > > The folio splitting process involves several related tasks that are
>> > > executed together:
>> > > 
>> > >       Adjusting memcg (memory control group) accounting.
>> > >       Updating page owner tracking.
>> > >       Splitting the folio to the target size (new_order).
>> > >       Updating necessary folio statistics.
>> > > 
>> > > This commit introduces the new helper function,
>> > > __split_folio_and_update_stats(), to gather all these tasks. This
>> > > consolidation improves modularity and is a necessary preparation step
>> > > for further cleanup and simplification of the surrounding folio
>> > > splitting logic.
>> > > 
>> > > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> > > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> > > Cc: Zi Yan <ziy@nvidia.com>
>> > > ---
>> > >    mm/huge_memory.c | 28 +++++++++++++++++-----------
>> > >    1 file changed, 17 insertions(+), 11 deletions(-)
>> > > 
>> > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> > > index c37fe6ad0c96..abde0f1aa8ff 100644
>> > > --- a/mm/huge_memory.c
>> > > +++ b/mm/huge_memory.c
>> > > @@ -3567,6 +3567,22 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>> > >    		ClearPageCompound(&folio->page);
>> > >    }
>> > > +static void __split_folio_and_update_stats(struct folio *folio, int old_order,
>> > > +		int new_order, bool is_anon)
>> > 
>> > Is there any good reason we want to pass things like "is_anon" instead of
>> > just querying it in that helper?
>> > 
>> 
>> The reason is during split, folio's attribute will not change. In
>> __split_unmapped_folio() it is queried and set as const.
>> 
>> Otherwise we need to query it on each split.
>
>These checks are extremely cheap. Do we really care?
>

Ok, will remove it.

>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

