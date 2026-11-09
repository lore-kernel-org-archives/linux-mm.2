Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F1B0606A334
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.a=rsa-sha256 header.s=google header.b=R9wfvv+Q
Received: by kanga.kvack.org (Postfix)
	id 73B766B05DD; Mon,  9 Nov 2026 11:08:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ECC36B05DE; Mon,  9 Nov 2026 11:08:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D86D6B05DF; Mon,  9 Nov 2026 11:08:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34AD36B05DD
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:08:30 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7DE31C4126
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:08:29 +0000 (UTC)
X-FDA: 85416063138.10.E7CA3CD
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id D6332100009
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:08:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=R9wfvv+Q;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu;
	spf=pass (imf14.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.219.51 as permitted sender) smtp.mailfrom=stern@g.harvard.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4SBBPsSc3/Ep6nC8xR1PMHfDpiIh8UItfXg1xvFovQw=;
	b=rUv60TJq7Ufzt1IRC+381u1mm/02PFKeGPywhSGMDJCeo0NbXhFkE+5GxDLTi8WW5bPegG
	grForYQy8p33P3IbQYNIzGtEnkHcobHqADWCscSxa/kIlUmsNBu5G9g8PeNdElOSgNSkFu
	Jki/AiY8L+yW+qw+qaY9Uiw8iQm+daw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240508;
	b=tBZzizkzqSAegCArzsgy3WGPAEbkYjbDRNhVlmSiEWDgM1MpHXYAjGXdBLxG1OQj5JdB/x
	kj4/y7WelGgh6IF7xNjVtw0uKEGTTrrdnPdPwg4K3dm3Nnlpluktz+u3zFdbrgm7LHplgO
	i2lFhyo6kg0+qcCgI7dxTWOgYkR8nss=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=R9wfvv+Q;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu;
	spf=pass (imf14.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.219.51 as permitted sender) smtp.mailfrom=stern@g.harvard.edu
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-91ebdf1c2d1so11491936d6.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 08:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1794240507; x=1794845307; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4SBBPsSc3/Ep6nC8xR1PMHfDpiIh8UItfXg1xvFovQw=;
        b=R9wfvv+QrWLLRMGv4Ad1m3/X42eAIVgYt9vkLrUZz50ebwMN2FFpUYaZ2d+MpSBalc
         +szYEF1p05YWgq4kNl11TGw2nvXrSXxGj7o8DX1YECMIqR5kMh5c64sEtVD0+N4ON3cH
         axARl0Um4VKSBHEJkm/RYNwJ2HiK44RJp14BmL6YRg2Mr5Tv7lpu8mslJdrRijHdpmqW
         mX00BwX6/y3KHX+JM9/MgEJSTcUii6QXcA1DJmbwyzu316JLB1jlJEOt0bJjqODp/+p1
         1AYQSglYGUUWFN7Q2+xvIIh7UAfKX9y7Rd7HGkS1LCNhk9/YmC/sb1OUYqA3xn8VeasY
         3/qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794240507; x=1794845307;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4SBBPsSc3/Ep6nC8xR1PMHfDpiIh8UItfXg1xvFovQw=;
        b=2kuD1gCnQNZUMfGkZmvZ9ZNL3loLQ7Peg/8iW4V8JPfA0VajaGeO0gSNtN/KzhjGvU
         X2AM9VAht9XXLBc9Rr/5Qwk0olg6vumN+BI9yzrJF98++sW/egvjc1UDX+Xwbu1egnzz
         +YJk1jmi65KBu2KuQzNwsEv+afqLVaJsFJeIyAKvi4TXI+IYNJyWRQFMAMAIF27/Y8gg
         l2YPWcqYDgJV863QXLT0omhkHDcazk5+82tI72+xOcFCN+1foUT5hrdiLoacDY5XQJRn
         VEjCLInXWM99jjRwd2CPDBOUE5UTzSW9+egvSQXpMGguZ43tO28eIjrWVJSaa6aUwbKd
         qM9g==
X-Forwarded-Encrypted: i=1; AL+hErHEPSJAktf4uk7hBkhA0K8Kuuq2He1RFQOzvThdPNg3iCv4Vpokkp8AqH0FoGildgsc8iDW3gOMAw==@kvack.org
X-Gm-Message-State: APuU4Z+Ef38Yz/jPIOCqwCPePCMHVSYThpcU2QV47c6DnhoUDpqMUO88
	V8rE8KdjMczbg7u6PeebWDLD36hqxkJJVHi0w7DHBJT6uonZcV6BWIoKcczDRSBHhg==
X-Gm-Gg: AYBFou2qJCAC5jA+2XYBgYizC9+IXHP/nMxY96Cp/8YcNQ0bF566cdyb9wopmwGfNb8
	ny9gK5qYU/onrPmCiDW2WVuDuVhpFAUrEkxZrloWGmRloDdUPl9j6VOxL4lTk/ZsdcAmCfKU3sq
	+2/UsQb7BlZA33quFOc4myICuQr6zZPEgkvbPsoP9+SNCefeBYD0dAaFEWQrCvJE02BDyYDxGsQ
	VP+Uh1QU5uCCxw7pPJ47XJY/ASpW+OBeBGon4Max8vnrT19zcvf7UPTF9IJ993UQrRCpbsLH6Vl
	63LtIAtOSKvRlivoDjIAmnJPiBW//ZqJGDVSe+wwv+4Y+yiNYYRPGxQ88XXBBrrv43GCeUX+GC/
	euyqCkV9mFsAFr4mtiDYXQmjNErvcehSm1pj5qV1qzJn3JTW0l1MmBZEEqaffFehLe/Aivr8rFl
	WjRlLXWoodXuLY6/o1WbyU1c9+9xHl7X04bDzD2oqXvKk6EmVtxCPFKmaqdnWZclX7LeiWIZcVb
	bLXHYiPESbWmHwWEAQNoXPN67/YC96NytBxkchDGL9EaCtf2dPlqxNzAurVgMwBWHEjTwB6RCBq
	hFuSK0u3O+tRCUiwiDV9FHluvQk4
X-Received: by 2002:a05:620a:440f:b0:93e:d5c1:da49 with SMTP id af79cd13be357-947842cc78cmr674785385a.82.1794240506826;
        Mon, 09 Nov 2026 08:08:26 -0800 (PST)
Received: from rowland.harvard.edu ([2601:19b:d01:d210::66b0])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e61c333sm7310285a.3.2026.11.09.08.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:08:24 -0800 (PST)
Date: Mon, 9 Nov 2026 11:08:22 -0500
From: Alan Stern <stern@rowland.harvard.edu>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, linux-usb@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] USB: usbfs: replace __get_free_page() with kmalloc()
Message-ID: <b39fd45c-657c-46dd-94e5-af7d633d297d@rowland.harvard.edu>
References: <20261108-usb-v2-1-c9209d527559@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261108-usb-v2-1-c9209d527559@kernel.org>
X-Stat-Signature: ei4uq3b9xz169c1f3y43q57i6dw4xin4
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D6332100009
X-HE-Tag: 1794240507-174352
X-HE-Meta: U2FsdGVkX18CrrRLUFY/r15PaDBciS+iQb3do/VoROy6OlB8LnqqI18cNpwLh+I06kiTbJx9UzAfeV0p0WbUO910WwpMzSIUI1uhOqJOSL+28Gq5G3BNh0kuQZr4odol5qUjhJAGuwn6RVyKUc3bN9aV7tXLq9w7vEb7ecRPwLM3Cuxjuc1OXXK5pFrFlqjmbQcFHg6SvyMWVgP4XPdgsUcE/eCpHI4wSQB99YDPBIw6y0EzFV/pTDlLYa1sex9NSx/aI/Utj/PbO/8aKt2VQzXpkXdZZTftl9Mlx4ALrg1P38cNt4U7pZGmOZD2mxX7xS18CBhJ51kwR1r/iPF83D6m40LtbtCyvOJndMTQGJ0abBphvmRXcrYv/f/JqAaqwhcUNvK4QkPna2YRvdAAsKJSSOjkbOFaQIfZP+5AgmEynh3oJ4YWKKy7rgwjwuc6MrbECId9sejtL0aw8qGa+oL1X2XE/t9xnUzsH8FI9pvtPun7FVleEx60+2PmxNa1B3ig4FBBfBXGZlOCblOqGk+ZZEnJz4uW0jT6rzUzxDVE1E1rYsnwNfZsqaebEDzEzI7kCZmKig8t98OUaKLscV3zxHW3YSzMwbek13smZ2t0mF4cq655MW6s0ZCcpYM740o7+8q8w8iMy8qouUKK5gxGC1P13UENYb4fJ1SrN8pQF34+PJygS4twZIv43CVBFBccLa3YtytsQPwXmn01PzhkLLn0hJkMjIXKc76J7+GpSv14BCQgT9v7873il3kjznMC6mBNfMS0GmqbESMoonyhxLmr87dyVisoS0DoE2dyoEM1vjbyyYd29gT/1hrggSau15LvILf4vAcizrUe0I5qdUpcN2/hHH7BDrDiO3xjTcnx21GhYNw3JAbOPUL4Q15pfFv78TTkkydL9tzlMASPkPe/XsM5hQOIJLq7360fITtGg2hHUNT4WCiE4oGlhqQSuLt2fGGw8zLeBVD
 im2vQBSk
 uiVYbrXniwBszHg3Gt77RvdkqqwF4e8OY1r57tA3OLNfRb4aiMIhzJp82A9iCSIa+RTtS0jvulhCIiHQ5BykLs7l3CfqIUeU5wiJe7d2xQo4V9CbtUYpf41VvFmQGFlG028fWKPD1s4I5fJDbQwpt3IK1Z6RyhSDNqMFUjPerw6P2L28MJ+lSw3rxOwCB5FQu/jFlpagDtg6lI5Porj2njasERgh58f/WCqcwoj/So/PRGYJDngiyUYlfHginX3FDNHgvRawQeR1VTwHd3cFvj3/wMa5WUdDTIxWiM+SW373loVeHrqCigGXHIdA2gFJRJZLpqoew6lOy1FKsIxCnNSZWqiTKeEkS9KeAIkG8LPiR/osObhyQJkFpdLcNbWrFefazu1HxTLYnaVoJZJCLRua4mcTX1F8xFNsK3yDROZO9LB2vF7K35DD0I+g199azJ01LMEoRY3TWlwi+xiFZTQlP+rWSGn7NEywK5yicFTd0vadbjIBQRblQhbpMccLytXIpjouZUkPA2yRiWibhMX7Qqlt8T3qUJtiSp85cDhsy/+JxfUAATnIhOk0j5rkunwL24VDldzT8Xzg6du/hGdxG8uGR9xFtJPpnJIZ4d/UlqV+eUNTozCUnWE6OYjSPDahiq7YJyZpKDaoDh4cxjCr5X3Ua7fRhttRMGWNdFa3Xl43SIOIIKILzgANatKYSi3BmX3MPsleZkbYySXOqGRAz0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 10:39:34AM +0200, Mike Rapoport (Microsoft) wrote:
> do_proc_control() allocates a temporary buffer for the data stage of a
> control transfer issued from userspace.
> 
> This buffer can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Performance difference between kmalloc() and __get_free_pages() is not
> measurable as both allocators take an object/page from a per-CPU list for
> fast path allocations.
> 
> For the slow path the performance is anyway determined by the amount of
> reclaim involved rather than by what allocator is used.
> 
> Replace use of __get_free_page() with kmalloc() and free_page() with
> kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> This is essentially a resend of the "USB: usbfs: replace __get_free_page()
> with kmalloc()" patch that fell between the cracks.
> 
> Alan and Vlastimil agreed on v1 that the kmalloc() overhead does not matter
> for usbfs memory accounting:
> 
> https://lore.kernel.org/all/8cbe558e-7f53-4ce4-be8e-52fdba9105d4@rowland.harvard.edu
> ---
> v2 changes:
> * drop already merged patches
> 
> v1: https://patch.msgid.link/20260830-usb-v1-0-aa349c302246@kernel.org
> ---

Acked-by: Alan Stern <stern@rowland.harvard.edu>

>  drivers/usb/core/devio.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index 101cb94254809..9a7cc7cdf00be 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -1190,7 +1190,7 @@ static int do_proc_control(struct usb_dev_state *ps,
>  		return ret;
>  
>  	ret = -ENOMEM;
> -	tbuf = (unsigned char *)__get_free_page(GFP_KERNEL);
> +	tbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (!tbuf)
>  		goto done;
>  	urb = usb_alloc_urb(0, GFP_NOIO);
> @@ -1265,7 +1265,7 @@ static int do_proc_control(struct usb_dev_state *ps,
>   done:
>  	kfree(dr);
>  	usb_free_urb(urb);
> -	free_page((unsigned long) tbuf);
> +	kfree(tbuf);
>  	usbfs_decrease_memory_usage(PAGE_SIZE + sizeof(struct urb) +
>  			sizeof(struct usb_ctrlrequest));
>  	return ret;
> 
> ---
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> change-id: 20260829-usb-ad052ea1ffad
> 
> --
> Sincerely yours,
> Mike.

