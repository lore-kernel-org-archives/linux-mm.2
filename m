Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FB9ECD8C85
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 10:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B7906B008C; Sat,  6 Jun 2026 06:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48E2B6B0092; Sat,  6 Jun 2026 06:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CADE6B0093; Sat,  6 Jun 2026 06:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4A06B008C
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 06:22:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CAB761C179E
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 10:22:57 +0000 (UTC)
X-FDA: 84849099594.02.FD74F8D
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id E28594000D
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 10:22:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PZkAkAFL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780741376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+PYftnEwTkOLQeoNu4nW8+o38nbEt2RMPyp6dfwToa0=;
	b=q69JgMHvHyEx56wTXwda5jofTiZDc2h6IxvX12AwAmxtLBAwfc6UgyFd1v2FMv1Y4MIGh8
	Ak8WWPMYteEyjoeQ3Bc0dH2x7JK3qb+zS/hfWwBDZQsWPh5bFODRrJciowwF4MZff4aiSr
	FWgyXYF/m2hYKs3eR1TgOh6Di+b2/7M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PZkAkAFL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780741376;
	b=hFFXlcrw9i3H1H5TIiD8uX1g6l9oDa11MXKF595hMcN0RBmqc2I5GtOEqJidLXTQqDap0C
	nVdwyJfTrHvKb3BbzXgTdbkD2KbwkOfdhTBMdzKO//MELyEoacey6+6LwzqR9M5a06KBBV
	Kdq9iNdM6KbTXTpm1Qs6OKAnLPLEe/M=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490ac357c55so32593585e9.1
        for <linux-mm@kvack.org>; Sat, 06 Jun 2026 03:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780741374; x=1781346174; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+PYftnEwTkOLQeoNu4nW8+o38nbEt2RMPyp6dfwToa0=;
        b=PZkAkAFLNK0HxLbi5R0hz2LvKjT0uSbPlmOphJW1IT2HAhDpnWcPUR8hHp04e8AFyJ
         pSkD7+fbltdUAgF7hV0XJc5LKPS4WnkAo73bSlgZEnLQFE1hHtW54ObaFzqnBWsCNHqR
         XpeZ6ulCg+QKgr0ROiI7lmRVpkU0owoxcsKLwDVvvXi/63FO7j5EYnmssq+dRd0ECbxa
         LUYRcKgE88kNKAJRNWs7N85FlOIORCOLn/5aT08iKVtDI0BEGI41kovNNKOOSOZVYITA
         6ivOoPUZT0a+nYs2sMU5W2dH62pIQsbrU5lIC8eRmfmYOkt0HbXGFr+7QvFHY3rmNos2
         l1zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780741374; x=1781346174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+PYftnEwTkOLQeoNu4nW8+o38nbEt2RMPyp6dfwToa0=;
        b=bGrppq5eN6ZakJYlpMBNgWolVlTb6Js80MR9UpEs5bRosX+KHU1t4s8cYzjjPOnnZX
         reb5IWQK708ZAuyBzkTgy6e+Dc8ySIHmBIFGWDTWZ54LM+T9s7FWVIYov9V1BLz6RXbw
         rWx5wrZfvIsamq7TFb8ucEk6FGHtkVSL3nOvt9+5D4YRWBCbcHdrQS1/ytdCbkYHC4zW
         9mrFnM36Jq2gq2nimPFG0b9Q483830ePP+ajPxzDAc50cyZ01FfZqd/g1Q013+bpMQfv
         dkoSdHGcaekLVv5CkVZO6Uj5iMA+OYgrep+ujejz2JHizJgWFLNKv+mmxJm4YfH8zZje
         4kBA==
X-Forwarded-Encrypted: i=1; AFNElJ+8zbP9WHY3OjNXRtW+W0Q4VA99a/FQdkLPLj01Oyh3KNW7F16SuhSE5iBa2Ts5oJdYSSCgwIDMhw==@kvack.org
X-Gm-Message-State: AOJu0YzuQoD9iul7dL5gTZz53kIkcil4idBAW1HO77opk2fynMHUH3iH
	yalkpqZrW0fZ8QrWyXGQhLEusJc8VbkeOoIlwheS0aNqQsd4rJO/WsuY
X-Gm-Gg: Acq92OFFkdGyDRNcvZDH+bfBDWAO9eVLwRHnXQpc1fzSRTjGuW1oTWoYZmcgDU3YhKy
	qHI4c8eDMnztox+RcY+yC7ZxiTAKiyY1Vb6RvfnLb3jZXEMVtqr2rO8UqYDLe5fXHu3sxpPKo6r
	ThUDX34ATQih1dFZmpA/CQs7E9rKs3jj5UB/9bb1nGq6X3/uA7ve3TC2zek2W8Yxc1CptwiLPtX
	lphiVtxG5UBRAEDZqpaqwggViDTgjxzgam+8TiMdeJXXmOax1Um5U3rflhlgrMDv6eq3sKmwhUp
	/Yv2OnFhdkmHDhxTi7itfU5PLjDbgLG1tp1Vb4Bd5oBB/IxDBFs+8UWsP6L9ihR8OIutcof0S/0
	GNhmn3I3TvJR1JqX3AZJBrG9e9K7jxZ1cI6K/mKaw9ltLlfPeckRrM5JTjToGHzWgPRVFHQmvGc
	WhURlxYcFlrcHlEPiRns4YHe2AnuJ2xsaRzA3RJFPYjoWKQ1noQ5mICza8cWD3TYC8P1Qb4p+bG
	5XSdkpILQ==
X-Received: by 2002:a05:600c:35d4:b0:490:b8d3:5dcc with SMTP id 5b1f17b1804b1-490c25e4634mr128363515e9.19.1780741374229;
        Sat, 06 Jun 2026 03:22:54 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dcae2sm35545066f8f.6.2026.06.06.03.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2026 03:22:53 -0700 (PDT)
Date: Sat, 6 Jun 2026 11:22:52 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Stefan Metzmacher <metze@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski
 <luto@amacapital.net>, Askar Safin <safinaskar@gmail.com>,
 akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org,
 david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu,
 netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de,
 viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260606112252.3c70bad6@pumpkin>
In-Reply-To: <634c8ae2-3f1c-46b1-b002-1e2ac797dd80@samba.org>
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
	<20260602225426.122258-1-safinaskar@gmail.com>
	<CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
	<CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
	<CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
	<512d948f-7883-4d8c-b2c5-a777e70ca975@samba.org>
	<20260605131942.4584728e@pumpkin>
	<634c8ae2-3f1c-46b1-b002-1e2ac797dd80@samba.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E28594000D
X-Stat-Signature: 78t6eijrqha764ys968n8938igfxrab5
X-HE-Tag: 1780741375-822160
X-HE-Meta: U2FsdGVkX1/gfpFcJZzDbv87o0HdMcJDtXB0vIUEavK+F4wRb4dFwCwTkff/LRBvYEl740HnQDUt1VyLqIc7dgHlniCALWHeYey+jxwzNZVPQJDW6RITYJFpMHnndnQtYk8oDFFB0sXcMctledNuCcfx8D4F2c5V98nYnF97BAh7+UILzkrk40V6YI7/+W6gGznLprXoJSrXcU2OSOZqfzMwHiWNA2XJkxDFr4xHz1VArwR5GUgkSr7T7FYGsMKSYUlqFyvA1CTFbmfyDipZd3JOWzsp4gvNBnEBfxO/T4VNFOwuTQ1nyrLLShaDdQFUurZjjHqMBncv6FpGch44T5DGX46WFER9XvqCazDH0wJ+bobe1Itma1RmoldZhAjCVCq9O/ZAwwkbUL7b5R1JbW8hlnzRrIJZ/JQxbmXE3I0hx6u5jxEcVDMYnQrRP4ZauMmzsmXYeiD8P2HPVAmlG1Uc0lCZeX6c8QvUetCTH9APzfR30+jLMGMLCbIXpuvhR5opDJdqZAuhoUeSNoqp0F0i0h4XlQcolvCxR841fLXHDDH1nVFRX4jExSJK6Um66yy8Bv5MAlEnUqqpLZ1ff9ecXqgACuN6Q/NiLfReOnJkrpw73e7uCF27XmX6rVi3orE5VsYfCz256MnMXl/H2r9aTs/wKBZWh+QcAhjFnWGzQoza98XX8WpGQyXB1UX2lX4opqktDBMlKWYzVLD2RbidjqULy4SNic2LSMRwSOJd0c8q8R0Rb6pk/UWBl+qH0x/YCJyUwt/KwzAtpyu3XwYT/+U7W0gNMEMS6nKWMD/wmzPcQYuywckd72iBn9Qri8lMEsI9wPJCPZ0K9JFGq6HBI28FFksujI7v6G/ToefOE6vYHx99YSRxBOWeFeFXswARyDmn1HmniWLEn8AiQ1b8rg2G0j7DS05dtiH25vPkvzSXG8dsmaF6nKfAfYgtRoHDCn5aPgGA57VaD3J
 PMoRYgZT
 mJj6W2uhDA8SMVFC6nAzgUypOS+bR3PDRIr1av87RJhR3ukVOWEQuNsygUTRfk1AvNvEdiCR5SJZ1Pre56EIVUr9DLskun/NsyCVhd9djN/ZKxqwlnmkh2JAISPcu3kBmU9vUxWcXrs9SS3QhScl6DyF4y0qRYoMVMw5xPguV9XVlI2Hdkg2wEeR3Nsq2OVaZG4etlUlQgvul9BndE4Ct7hTv2BH5Fg7gG2LV7NWFfIyokQPQt7cfJmnnHDZLn+JpD8bpvMooHAqQYMwKhTpiyml4yyhBD62JbnThEMDLtrYIeVpPO7R3ZtvUNXXwZoBaencIrup4utBfQuPeIH0DWCbwpgclCn9vZ22y1NUZQzbYqF8K5SMTFtNT29ymyh/tEehnjeeZwxP2AzbMKdgn0fcTPnXmOqjr4a1LmoV7a3OdpGQJj4ae3L9slDXAgXTfjNa9AHeMfnBCvlMbRQrU5+GF7hJF2Dcerg6UN4UalFmbf38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Jun 2026 17:20:34 +0200
Stefan Metzmacher <metze@samba.org> wrote:

> Hi David,
> 
> >>> So sendfile() as a concept (whether you use combinations of splice()
> >>> system calls or the sendfile system call itsefl) isn't necessarily
> >>> only about the zero-copy, it's really also about avoiding the user
> >>> space memory management.  
> >>
> >> I don't think so. Ok, maybe for webservers just serving tiny
> >> html files, that's true. But for me with Samba it's really the
> >> copy_to/from_iter() that is the major factor.  
> > 
> > Is that copy also doing the ip checksum?  
> 
> Not in my tests. I guess there's offload in the network hardware
> for this.

There will be, it is just whether the syscall checksum is actually
being suppressed.

-- David

> 
> At least at the syscall layer of sendmsg() there's no checksuming
> happening.
> 
> metze
> 


