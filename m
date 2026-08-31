Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB02C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 13:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03C236B00A1; Mon, 31 Aug 2026 09:27:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2E436B00A3; Mon, 31 Aug 2026 09:27:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1CB26B00A4; Mon, 31 Aug 2026 09:27:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAF106B00A1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:27:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 35B1D1C01CF
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:27:13 +0000 (UTC)
X-FDA: 85161640746.25.3F83D68
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 44221180011
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:27:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HbgNdH5h;
	spf=pass (imf24.hostedemail.com: domain of oneukum@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=oneukum@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788182831;
	b=eNlA2hqad0V36FdI4hzpGYQM4dxAd9BgrEuft26AfXtus2TXllTSF4sBhbvWEzZwM5F2uN
	O6jP5IIQJYO7APefvEd8fnpqk3W7fTcdEY8mDzhGKOCCCPXKey/Im3QQTKOyDeXcZKOssz
	Za2PLmVqN3f5zime6Q4eRijXquKYb+k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HbgNdH5h;
	spf=pass (imf24.hostedemail.com: domain of oneukum@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=oneukum@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788182831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9dJl19p/pVq6YV4fVMLMZrL500AfikOykyPbafsX3fM=;
	b=2nbykPCuSSqmUOw9a2Xed8UHm8M1PmUDzoVDRD9JpxDVCYLJeMqaTX9zz+2nWB7vkeVZby
	jodeOXED4H3usE1lUD5Ok/V3sA9H//eZ5knTJVU0gH3RcjLXExd1vtN8REcPEZDl7oUMdk
	RbobBKgUds32Gf+AU3fupmTjEJk7DBk=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49cca4ffdcfso17727835e9.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788182830; x=1788787630; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9dJl19p/pVq6YV4fVMLMZrL500AfikOykyPbafsX3fM=;
        b=HbgNdH5htWCswUGf1YkL+h2I+qT+cjxrHXezBM+g2T+2rqqReQCN+0P/y1E6qLKqAY
         g/ihD7xS9PXFAUqlqtt3P3rqz0n/79GUVXaUjPspGk6ZJ4c9obRbv+GC+PkmrPenFMk7
         WehPDyNxCAhEIYlRhnvARIoITjDUccPaLFzxioyQ8zkzvgYHQ219vV5RVLDG2SCHe2hR
         lWqLuo+ldNu2qL49pVIty4zpRRnp4UFd0pDk28rZ8/+mADCduUYZvYfu2qRQOaQTYgfp
         hQPpOER5jbFwUHqI6iPEJYc5LkDan0Mgqje30MbpXpCu/87Qz7JgJAoGrI4W+f9yIg3U
         psIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788182830; x=1788787630;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9dJl19p/pVq6YV4fVMLMZrL500AfikOykyPbafsX3fM=;
        b=pEwjfoekKujYKMrHoOLuJM70/t56zfTh321geYG7Lj7fHquB8IEo7F/CtiFeEd1QD+
         PEU07GyD8BamFbvW/LjSG7JtmFSggob6bLYi0AznuouYaYvMTINUvK09nHyVNoggDJHi
         i3yGYg9cqXa5WVSvcWP0b8hxW9xxkkHZbBgbGADPwfvKewfzu8DUuX5tRg0xM2R4quwp
         07lLMuta3uP379/g3/odfNhblSpsyG720r+4jm1ucn7c0awCMUwQaQp6ia8R46/MnHF7
         sJXQPEktUy13xuUMOFEXCK3NdCe1P/ZG+AdWPVCVT4uzMXR5STwRXuY5tRSGKdDDzCrP
         6j4g==
X-Forwarded-Encrypted: i=1; AHgh+Rr4AE2HZRVH817F+wnbLVOL7zgmt/WoVz24D4DFLqD85lSAb+b8hvp4N7OFCkVDJ/OCMUiTEbklVQ==@kvack.org
X-Gm-Message-State: AFuF++kSRuudywlGYyKrvHa1KbA1eBUfycnIhvGBv8m2Gb1M9rTqhXxT
	ogH5eb15qae6H2qh4mjbOz8aADRoNKtEIcU8q7hDBQ8sPRD2/V7xh1ilco7gEvnBgiI=
X-Gm-Gg: AR+sD10F90VamJSDzTzQAVMoh39OYambpZn4zYEy5xwA8uOwdu8fZmmth82gyp3wGEs
	1nLXspgxXJcLpnpXaQ5J0uoMQWbKNJGr74hY2oXP4qQpzpsD0TqCmiU/o6uO+of4KmhFHhIuC6/
	IEoed5fr9dLWO/omeMMEJZm3EEzyb/p4aQ/JghVDyzBJ0btofKBWg70Ltm+DKnfZ8WtHF02DdR/
	/pISEqZJbTcmunJM7r1mlIsU2r0iOAW13RZfYnWKcJqX4nX5Gn32qorUNOOQJYa2vp6eMGBIMNK
	qEFsYk2JUXfWGml7qYnmVfxA/10gMV9+5xPWZmiUaFru+jNvGLZA7Rpkni3V5So5wQtYk70THLx
	4cE0PQ+dzvRSO64xHWfOrA0V95osi2sUYFZYzNzoWLn57rb/jSuA7yuc1Qkzkxr6xn5fBqsc+AH
	NoLWAW3l/nKIs636PgJYOFr7UDZddCGMga0Ew8AfYwPdJ1TiUS4fbBzjZyCPxu8DEnsQYJ2UR8D
	4W5WM1MEvLUTEhsw4AKM0mKrt50GEc=
X-Received: by 2002:a05:600c:3511:b0:499:adb4:a922 with SMTP id 5b1f17b1804b1-49b91c4bab5mr295369375e9.12.1788182829769;
        Mon, 31 Aug 2026 06:27:09 -0700 (PDT)
Received: from ?IPV6:2a02:3033:283:b9b7:bec2:3dce:f757:ce06? ([2a02:3033:283:b9b7:bec2:3dce:f757:ce06])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ccea6b814sm176057695e9.0.2026.08.31.06.27.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 06:27:09 -0700 (PDT)
Message-ID: <ea165ff8-cda2-4fed-9354-1d14ac2d87ca@suse.com>
Date: Mon, 31 Aug 2026 15:27:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] USB: usbfs: replace __get_free_page() with kmalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Chas Williams <3chas3@gmail.com>, Duncan Sands <duncan.sands@free.fr>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Johan Hovold <johan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 accessrunner-general@lists.sourceforge.net,
 linux-atm-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org
References: <20260830-usb-v1-0-aa349c302246@kernel.org>
 <20260830-usb-v1-1-aa349c302246@kernel.org>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20260830-usb-v1-1-aa349c302246@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: af59pcgdisfm3c8droi3qnkuigxdfuwj
X-Rspamd-Queue-Id: 44221180011
X-Rspamd-Server: rspam06
X-HE-Tag: 1788182831-456879
X-HE-Meta: U2FsdGVkX18reAKhuEogXkN5d0tC39c3VNjVCxTYi2mOyON7uH7nelQ1X5tA/HLelbVlAU+CqY62mu1/Ip8Eb93DkIiJPJytaLhi7dVatIeIaaWSUrk7xmpLoC+TnqR3iMfI8NoIOung+CyQdKcJv9Qo9ZEC2nf7qx2polgUSEKVbgX0JaXS41cFsN1rZNmIrNOe388K1UOcMIYruiM7DRwIqnrqcPS2Qk1zClU7dAPFT3s9HTC70nOmcwQtVLaA5MOutJqBrP43WWkiEhNJhoH3ci6CektzTShoEFeiXmI3pR9BpJWG7wVHPAPj9wlzB9LPhZnZzQU+UowunmafptNvRDAeOiI4FTwfnha+Q+mtLyUxHkGIoY8c58uHJdkUsx/9YfUZKIBeu6r5V0X2EY3TZ/jes2XDyDmmo3gq4vp4ct+phGJX1F9IFzEaAAXEEQ3TVzf/2Q+llepVXn26QJSL5fsOagmJLgJ8LUG86Gbuv3SYLO72kRlcnGWgqOvpBRhEuCY+IbAXhrAcnVwJyRY7jtGGtm3ly2qdCmCiKaS7hjgNYQmeGjRDEbNeXhXHdQlXpQ/qmun9C/aDLG16fe02fyrOO2eQDrYcl15RRQ41vn4YhUhMPN8aEwhRGsrOj1qgpbNdRft+BYh5GRR8Zufitm1h07We5dYkHR3UwwGUAZZ/EfHcB7K5MWVJdQRuNlUkhVVhxu8M/qHt1dWaEwpUfXIaSn+oL2pnqoSKaNMBldljrOzZzsJg2b5Sw9JujK8mDs+oNR1xUotDJPRt2AfiojApZYMW6Ro4z3OMyMF2hABFk5h1Y5UtqXpV+JIcGFNHS8GLgl3cdhyC/fq6LL4XVvijUiKrobcHg/NoAk2c6zuCbiJG8uZThdmV5ejNMVuF6EYeTaB305385ESeQCMJ8sTYSTDFH9A5mOXEU1b+8FJgvm0IwmY0oKAPegG0hqOY468M1tbUQr1hDqD
 CKUjoS+S
 0kcFmlTJn4Ofq+rSSYZQNPl6paDJdX/K3Pi63Oi26pA81WLRHS0J7Hzy3zCBUfd66Kt6luP9/jcKvpeJofWoQ13RLvquNUEhFPfRqwbGzLzJeVCpJQVXZ4Llfy17ld/pDCyWq+eGrexLuRCp7rFuVsinHkMP3/LftkisVfzQ0WXEzbzlgwA74/HrINT7YHzHuleEvkonpg4A8YQ55LgWB7OR3wSMvuBFdHvdP6mffmrtElLWLPSZqB+z6Ygdnzxh2SSp86eXVZ1f2ovhYs23ER8+Be0KQWZJ+R4D9lNNKdmRj5sA9KOr914qKIKD6Qz8lvfB2f+EpbeBRHE69JLjpaip5twVBKqFKLcxZx3WuFBrQjj8SbVeKNuoapi2nmwqLWA9Ug2XjLC1Tgl0FkjRMOHXBHsVnp/Z3MTfj/Q03aNz0X7hHtUfy2f3iWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.08.26 10:10, Mike Rapoport (Microsoft) wrote:
> do_proc_control() allocates a temporary buffer for the data stage of a
> control transfer issued from userspace.
> 
> This buffer can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.

You are breaking the calculation. A page has a size of exactly
PAGE_SIZE. A kmalloced object of PAGE_SIZE is larger. That is
a bad idea.

	Regards
		Oliver


