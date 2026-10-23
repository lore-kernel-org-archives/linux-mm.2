Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58EFA606A327
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 12:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Zn9i+8vQ
Received: by kanga.kvack.org (Postfix)
	id 7B30E6B0B51; Fri, 23 Oct 2026 08:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 763466B0B52; Fri, 23 Oct 2026 08:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 653296B0B53; Fri, 23 Oct 2026 08:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44BB76B0B51
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:15:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D467B1403F9
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:15:24 +0000 (UTC)
X-FDA: 85353786168.08.D125909
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1A442140004
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:15:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zn9i+8vQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792757722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/O8ddyO0QswDNW9VAk+G7Y04FERK5OlichYw7LW0Zos=;
	b=MZt+hrj2W1F0JPuRWU7QXMnqu8LxU8xB4uGkCYV8yr/4GTdhBKT5swsVI1L1lU7EjYhOwc
	QBRe2KZEP2v6h2t84YaXuDEvUwJuVJBoLSd2HAauAFNDYsFe6oO7xLd3Jxl7TAgjVhz6UX
	YoFy1V36lzQ4hJTR9tFxOTLDZ+MN6MY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zn9i+8vQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792757722;
	b=JGq70Pjm6aHrWnxfc34BXuL+Xop+3eG5WNIVfdIfDhGLB7ok3lTrm9tX6r7MJqovRmbPJI
	C2ewUM3pEUl5xcQ4np+s+nK8OOKGrj7akiB9PfOiqrsfPzRh6bWFNXnJeuDvLZLn4j2aGS
	DUb7nrlnr6ICtdrw7ULU71mT2Tb3EWE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792757721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/O8ddyO0QswDNW9VAk+G7Y04FERK5OlichYw7LW0Zos=;
	b=Zn9i+8vQrGhhwQNPzTCsu65h34SGbY+9yzVTCMc5q0HLaOCYfBpTW/nZF8OTxmC4IYe7Ap
	YA4uByuiqrnNcIcpjYouOXI8fSLISL66BnQGJidYxrKWXzI72kbvz/W4/1WsSEBLgzt+Mq
	Cyluclp2BAuT6Esl4J1Cv0ddn2YkI9g=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-U0OQd-7TPOCxEQUI5-97yA-1; Fri, 23 Oct 2026 08:15:20 -0400
X-MC-Unique: U0OQd-7TPOCxEQUI5-97yA-1
X-Mimecast-MFC-AGG-ID: U0OQd-7TPOCxEQUI5-97yA_1792757720
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-9195c59ac8cso25641126d6.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 05:15:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792757720; x=1793362520;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/O8ddyO0QswDNW9VAk+G7Y04FERK5OlichYw7LW0Zos=;
        b=R3ZObXgl/sR7axKGA+mCgbn7s3nQ/wl48QtKq9nnCLqj9+JNh9vwmcRGDkKLMu8Bkh
         17xa+NYAdLpTHWHz+UPrWW+4x/OaBGCms/7qmNJYKUQT3KTG+gunYAvgcxFXg3SEH1eE
         p4Nh8CxBpLVr3Ap65VJFVeoyuDCBJKM7ZIIPyjRqjedjm9xFcpDuFiXUXwJWjg2j7/Yt
         dCuOsfeJSrYdW3ZvBOsGBY1qeMev0xwivmvkiXXvd8Su+b9GdGKQ7HgsphRygrllRihg
         rHKlySkRCkSawjTnAia8ojoTFAykWPO94Zb1vsllgynJyfjdCLjBobXAWgFyoGvn4pPC
         TWcQ==
X-Forwarded-Encrypted: i=1; AKwUvBylqBlH3FxlPfqDnjOTaRBL3FWXwThE2jV1X5il5uv/nXtJ9BtGXqpND5itPt2tbfzM/olH4GhnBQ==@kvack.org
X-Gm-Message-State: AFq9FYKxlVeDb0VwhUCtgOKPZ1cqRtARAbc0vJxTGvF6199HYnGDL6i4
	os/arwZMVb0cW6sFKlrhp3ZDiGeOJOalKH3gXyuB75jM5osMcsaejMAqCLJY4sJb2Lzvo11wzrk
	Qaghl2IA99f+osXPY3RyHkjX1STK+quWpteUUqevlFf+O4MS7FWlq
X-Gm-Gg: AYBFou0dPkyFUeWEYI03xrv0mD+rwYoeQKKa9HEBCQGzwy5Q9hfUaSkjfckHmq4bNrv
	Jl/6meIXvjN0Ql7qmUrxZ90qyagYoRg/4hu1RB/f+qctXYMHkQ/J0tCHFOrXkgGs89MV56mUPIW
	uV13fVidb5yf5+3iH+Yo5i/rc1ROXT77GAELepHT73vOma5tThwZajPNOLHWpMERmmAUVv9hfnK
	YTxTRs3/BOSjUFINEqbHfkqiGKv6KxlReGakxSoGTU/l4JsrpNj+gcBqg/8oE28XTwvCHRPKK0T
	zSrHhYI7joErg9UgNQh+ehvfm58HPycYshIFftb2IafwIGTB2FKn6pjRMlXtwZ4AhWJ5ufTW5FO
	NrqA=
X-Received: by 2002:a05:6214:5702:b0:912:517b:40f6 with SMTP id 6a1803df08f44-91c3ab11b46mr27423966d6.40.1792757719493;
        Fri, 23 Oct 2026 05:15:19 -0700 (PDT)
X-Received: by 2002:a05:6214:5702:b0:912:517b:40f6 with SMTP id 6a1803df08f44-91c3ab11b46mr27423096d6.40.1792757718665;
        Fri, 23 Oct 2026 05:15:18 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c45252a59sm19956d6.23.2026.10.23.05.15.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 05:15:18 -0700 (PDT)
Message-ID: <538f7c6f-3e16-4ab9-9b79-232b34fb4d3e@redhat.com>
Date: Fri, 23 Oct 2026 08:15:17 -0400
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mremap() fails VMA expansion when VM_MIXEDMAP is set
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 David Hildenbrand <david@kernel.org>, Jakub Matena <matenajakub@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261023023106.515365-1-luizcap@redhat.com>
 <atsWop95CHj6oTSU@gremlin>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <atsWop95CHj6oTSU@gremlin>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zYwV4b6eVKWzryPBVBY6AJEw34YAsAeeAZgJNNtz0HY_1792757720
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1A442140004
X-Stat-Signature: i7zjmcih8k4iamkritnqf91z4fhu4c5u
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792757721-810856
X-HE-Meta: U2FsdGVkX19dnQxGtUeMbBaawM9NoJm16p7HO0XVWiR3Cgl8BFaOHotA5lNccGmNBgCvAhIZj7isFzNCeu3bRWOB2eYJoSzaphCkxkWeX+cJb/I15dyPACXEJrWbrSyZumCyzk64L6v+ryuL/iUox3zQlJALWIjEYoQYFm7MVcLzNXBAZMmcbOIJM5jwW0wi12l4Crqv3vDVCc6D+4yhZuoxPadIFyex6w4NRP3CsA579jHRx4+z7GWlLlb04RoVhlNy+ZW0XeYumePa/WvPvGOwEfSewB43Ifc6Y8E+jd0uKEmQWnoSmdMp/3+//TewS5BrFsXAXXiMkwI0Z/i27pbK39KyXsFsp+DF1r8G1GXiMGZRhNK1zOoQGMEWy1uQtKbUHEjnwJzKIPT8BoCjxovD0jgoMGPVy0BLZbW5aGAkyO4VDEwj8uspAg0YHXJoOWSUWd8FJVIyU+aaKeEGW7ePsfZo+q5nZAvyrEdn76HCiEiTICja1TPD3AGrWHfIk707ESF0KVjMkKxyVX/GZOA0MwNEpMD2l2PzKcGK1cKoAsAd4VhgQNzp1bh65XExjsKbPHfF4HSBCAgkBIT+/rYpq8YFNszbz3EBw9I1frKByxbO1/6yc2z3LM5QhySI55LIOUdIIEpE7jPVDOexbGbiV7FcpjT3w6r/lpIFIwnpxHLPTJaHpt1wB/C3hgQKvmwezosWYx13vgjkxJGo2I/jm+g0zdsPWwZRlOtygPIkpFJfO1Lc4kZKEYQiNzBzx1bRkWUKhfpWPqp9A48rlUDAHnUM3Fw92kPu27DseA8fTHnV+rKmnwFbu4E1RwejUL1O9NBJXbtJEKN4inHzJ4ydFeBdsmUWa3iYyBGyH1e+uG2oHzIuJZwYOIpb1aXHgMIKhjawiomC15tODtp7t+zxWf4nTS7xnlszmAdi2i2CImFqmk5xCj64HM9Ndq4Lkml2ZLBNpId9v2UVcwV
 ynxx76p0
 9V2yCIbkCzhbe7YSW/3md60Eg0KaYbqXEuaKWkug3oVUek3WlMlFxKiNA9NOA/XgxZrICJ89ov0NBCQb/FsVv9XK4sWTyoW8+cXFvVlte4dSmR7SfUeeT5Mf611guF/B1s/3wcBOzzInfoMubxlWtVuLn4k2X9rb/A5zkkFfGXYVzPq2Axi8KILgOuPSF9mQfBhqi/SEJu45VEoUmHRv3gCcL9HYO6D+t/m6n/yFOer0tLLqWkeHoKBMUobDwU1U9KD7rpX7ahVDD32z5DbDac2ZXgV4oTnPpaXx5CzVIRbVpqEoJEImKpe+qbxhIct3sd9ltH5AnAu67Ie5W5xo/nyF8iWH/8Dp4bDGv/8yQyjXafVKy/7AyXlxL7nhlWiXbFPjZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/23/26 4:18 AM, Lorenzo Stoakes (ARM) wrote:
> I'll look into this but obviously we won't make mixed map regions mergeable (nor
> were they ever), that's completely broken.
> 
> The most recent version of the mm code (which is going to be send to Linus soon
> in this merge window) documents why:
> 
> /**
>   * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
>   * merged with another?
>   * @flags: The VMA flags to test.
>   * Returns: true if the flags permit merging, false otherwise.
>   */
> static inline bool vma_flags_can_merge(const vma_flags_t *flags)
> {
> 	/*
> 	 * VMA merging assumes that a VMA's flags and fields completely describe
> 	 * its state, which is only the case for mm-backed mappings.
> 	 *
> 	 * Mappings which are not mm-managed may have established state upon
> 	 * mapping not embodied in any attribute of the VMA.
> 	 *
> 	 * Additionally, private (CoW) PFN maps encode the source PFN of the
> 	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
> 	 */
> 	if (!vma_flags_is_mm_backed(flags))
> 		return false;
> 	/*
> 	 * hugetlb mappings contain per-VMA state, so their flags and fields do
> 	 * not completely describe them.
> 	 */
> 	return !vma_flags_is_hugetlb(flags);
> }
> 
> I'll dig in + get back to you.

Thanks Lorenzo, I really appreciate it.

> 
> --
> Cheers, Lorenzo


