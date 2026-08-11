Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30997C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B8436B0092; Tue, 11 Aug 2026 12:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 390AC6B009D; Tue, 11 Aug 2026 12:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27F516B009E; Tue, 11 Aug 2026 12:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 067DD6B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:16:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4480F804E8
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:16:03 +0000 (UTC)
X-FDA: 85089490206.05.8D49D88
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id EFFCB14000D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:16:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kAf1vlvA;
	spf=pass (imf26.hostedemail.com: domain of maxi.saparov@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=maxi.saparov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786464960;
	b=lpVqQCAOCSBuiGEjpIV+JnGCC/vYtKz6kF5srndVcfl9MJfhJ7KQYvwXrvUXf1Fs2hSQJV
	eOta9MnSVHsVFid0XNsp6qKPpHT+OmjbCvgxGu2RB/EY8mpidk52RzK6S5HlH9/Un76ArT
	sghOmByf9EGuNviAD3qgaCF88ktKtOk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kAf1vlvA;
	spf=pass (imf26.hostedemail.com: domain of maxi.saparov@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=maxi.saparov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786464960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yqTXzLSqi2PHpBqXcfI0CNlUPAV+a1jDZqtX7tQ4YaA=;
	b=CSOdZbYrUwr8s64yZl2dusWB75APP+R41zTBFgyCfizoRMs2FpKuaHI66SA+JBdiSvE0oz
	ZaNOM06stTfH2OUw3Ie5aH7hZeW9R/tqs/zOqobI0k5t7Tn2x9TIZRhd5JWEpaaDWF8d9+
	9RIGOICJqYNMk3mZgvtSP73b4qz7tSA=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e6391b114so8536285a.3
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786464960; x=1787069760; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yqTXzLSqi2PHpBqXcfI0CNlUPAV+a1jDZqtX7tQ4YaA=;
        b=kAf1vlvA+131xFOSObWCGUuuHT8bmGsVaSVjATEDxN0hDG3t+eNJ4mVFQrHttY620n
         acgAKlalg3m+mze9JRWfJqioL9WhNThGsdi/YAq9BM7+xKCLBNbJWEK80YVANKXk0lOI
         XtFZkxR74T3Hwc0LeX/myIFDHh+h0QarJ803kdeNMTwcPd2CqWAuTBXxvkP3Zbtn8eXy
         jPNodOIRYL6l0xgQKH6zREjEgAHvSL/mQpDWnBXhOSx0H0RbRkx8zQKf6mWlU8wt+nkW
         iRnpwJagKgv/GF+BgyLAd80B4P+Ne0OpiQe7ymhzZeOpCQlTxmH5lPza2vkyQBL3NjUq
         /bLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786464960; x=1787069760;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yqTXzLSqi2PHpBqXcfI0CNlUPAV+a1jDZqtX7tQ4YaA=;
        b=GkqzQIC5la+wQBS/h91jfkz/xUIj4ANJKh/ZJ+apwMcUzqHuRAmn69fpmGZuV4/QXS
         dtwKxePu0tiHnVeEbo2zJHYfRMdBrbZHM8Ym3Kq3hFBPAVVTePquBZIIs1KnMhvFRWYs
         bCNwqz24y3AILJA1DKFdYuCNWNNIybXEy0bvLpw6ON+dZoAMk2D/8R4iPqDQRH7lKM3o
         nonpf72xYhcRLkeHD65pQeNaYmTRLGgC7BwbpsmkCAEBle8AZbJ66UQTx6p+SdZX3WlB
         hWNC2BLopj+bJe/Q3cy6xnWT52jM226uVeNUSeIoTsl9LGoRUiDJIV87p8c3EYxr8bY+
         Ub6w==
X-Forwarded-Encrypted: i=1; AHgh+RoT1htrPgmn6CY8g7fLz6aSwdua+Im+WNiZVFu9PpdQ8sVTl7I+NJJ7zKHI7x7kyx48cFoLPdicfg==@kvack.org
X-Gm-Message-State: AOJu0YzJ0JPxz7yE5OLmL+XgzIYbe20tkKT67TV5GumGEtw06tQPgF4c
	/xMQz8kHrEB77hWkrpNpILEm3pNyjcjk7t49QurFlbQR05Q9C85Ubt5O
X-Gm-Gg: AR+sD13BWED2COFdt5R72LsvtT6NKFzc6jpx9DUaRDCYZU2Gae6AiYfzaf+CmCkuVOx
	/Nbi7CUG68r2yywz3xwqehlmuVFaqzy31/cmFpmqEsIBNv1x4NBJCahhwjPq2zQ/u6aBJEFows0
	lrnlvbsFLEF6Zgrh9Dy9BaeEKHJHNGiZTCQnt6RHO90+OkGBEfEWxHrpyTdxjFb4fpuX+pxZYEf
	3ps0MHUe4wYb/yMZ1I1wtAd3vpjdtttGSABfrVeIp+xrk231qHOHyahpqdYmOtFxlPMiozJzd9Y
	kh+jp1pgnqsDTE44mIp0RLCdk0H/EwvFs9RG1iA+aSED+BlgoVP3rot7K1Yek+MSn2oRokPrrO8
	ZFigZgAP1HvxpudmBC3wo6WF862kuHHYYfiGpiAc9CnbxSWdv2E8k9+aA+xVvvv7FBJFFAABUlv
	hG9VDsPs9pk4tDrG8ypL0DWEE65LNqScY64siBoFWEXTbpySdIbDSKplkvf+CwECAU9sODoE2Vr
	gbhYqgyVJlwErdh032PZmJL3vo9Vorw12Y=
X-Received: by 2002:a05:6214:5b85:b0:907:c025:e4 with SMTP id 6a1803df08f44-90a667db293mr50971636d6.13.1786464959922;
        Tue, 11 Aug 2026 09:15:59 -0700 (PDT)
Received: from CW-D0XG2Q16P7-L ([2600:4041:5d54:8900:9c8d:ddb9:b1a2:735f])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a6c29a1f3sm2428656d6.17.2026.08.11.09.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 09:15:59 -0700 (PDT)
Date: Tue, 11 Aug 2026 12:10:49 -0400
From: Maxi Saparov <maxi.saparov@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Evangelos Petrongonas <epetron@amazon.de>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, sdimitropoulos@coreweave.com,
	Maxi Saparov <masaparov@coreweave.com>, stable@vger.kernel.org
Subject: Re: [PATCH] kho: do not reserve scratch memory in the kdump kernel
Message-ID: <antJiVOAmzR5LNPe@CW-D0XG2Q16P7-L>
References: <20260803193938.8778-1-maxi.saparov@gmail.com>
 <anmKnlBmOssfqdbL@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anmKnlBmOssfqdbL@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EFFCB14000D
X-Stat-Signature: afmhu87afp8j7aowr4sfdeg4g1usytts
X-HE-Tag: 1786464960-943163
X-HE-Meta: U2FsdGVkX1+aWDzCEvf0QK5nfZqwSbCGMhkaiFGZHrGwtv5LY/0GrrLVDkDGerzyprnQUx1ls2wg66+QQX3OKyXvNO15Qro9h84Z5KWLg7M4R73OyqZlLk7k6kjdFNH92ATt7gEkQQgvnlAxVBnPGGzd+MnTOQZ2C6OBgjHFeIKicOow36HIrpWEDOwzyVYDuJubpQCS2Idc/wU1RutaqpV4RyHEXlllUOEmKi+FwXHjGeZw9SL0eXvt98DVz0eRTN16yclM5e2sYKeE6Ebe4zoaK6KU3fIqTX3UDBbVAwF8k9ULP1rp3j6qrUKpFC6Ww/JQvLOCdGSvZYgDdwvGQvffmRriRI9arHa0pN/O5fj3ZXRE0bsXM1X/JVGurWsbknUbhh7ulsHTCGfZPid3K5swkcfu94OPpUqUZcsSbVvQlON99vE+8C5mGOmOOgE1BOdEjLJo6gAD6zHfPjwusKqwP6fWVUeF5PIFzeqBb53jVgjRdrFOx05lmJdwpF8B3Spk3ruuc3rOf/fd3RiDhLEysjXRDzFHx3TUF2MCJPPA6xqIg19qwOidsQWmC5V2dCAKErLWrEfhJDS49NuvL7caebo8uk/2O7AI0JPw4Pf5CjIiertBu/sLwqv6AwHI4zgBqFy+gQIYbH6t3GueKskGeEudHkFm1o5ykAEcmF97x8nHcVPrM45ykOduCdeZyrSYwGxkGomy646KZoho4Ur5oechMQFHujet/Drm6UEb78uMaw0qyFtfgsGkVvCCFp1wWWp95PccQkHSBZbsdQnjv1kZEkXLNXzzcLkm1GxjC8pIEopLUY9wnZAemMDoPAEzH/eHtP6XWY0eAE5KXAD8hxXI3YEEjlQovhz1cFm/HrriIEue4J0f8h8A673bOO4D1D32eZjGViFjY/hYsDNnb5UzdqHnzbTcEp7p3LB01tEfBSKsib5FQvd23qDq7luSu5GIJxBTb2lVt6Y
 w/Mx1PKN
 q2r7CgVa9ZRU/aiVrdG6G4fdwHi4BmtUoJwpRsUBhtDS/QgHEpkRL8Q6RYGoOaeGILudMPRnXNwiSCrTvphQhmdvt1tQiWZwEgDfUjQNUZjyUBgymEFpUQqWA2QMaJ7/a4XqIfoy541LIkGbvG5qx2ITpVShJwLRLe/X3YMXq0esAP9U7kvreH7X1JPGFBIqOCj7c9rRo7zM7tK4tkKTCn7t4v4VKmaF3ZdDfS4bYWsPw2WkGfuggTXTq14WTnOycZfdYtTDMQb2uvhNdilNI3vndhGG0wa01J+pnzwQCCG21iBJV88RIrvQLkGkglfALrl/raBqA9QkElqLfRgFHnHb/47tj6wqv18U/WrHVYL7vMUFes02Gtk9p2ALyLVC7VWnVWZXhiYFwJFZvt7QNcnkFtXQNHX21wkB9VgMo7uNUUjMzHdWLsEX/F5pXtAywRwth85Gn2jEvZzZyy7fsqkcjZNPWaywF03p/IrCmvzgKRjvPJNB0OOBR1GcuamuIOgdU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, Aug 10, 2026 at 11:23:58AM +0300, Mike Rapoport wrote:
> 
> Can we put this on top as a separate if, like
> 
> 	if (is_kdump_kernel()) {
> 		/* disable KHO */
> 		return;
> 	}
> 

Sure, I agree early return is nicer here. Sending V2.

Thanks,
Maxi

