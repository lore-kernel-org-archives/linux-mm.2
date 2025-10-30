Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 832D1CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 11:31:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54FFB8E0144; Thu, 30 Oct 2025 07:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 527948E007D; Thu, 30 Oct 2025 07:31:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C80E8E0144; Thu, 30 Oct 2025 07:31:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22E278E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 07:31:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C279A12B7CD
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:31:55 +0000 (UTC)
X-FDA: 84054566190.05.FBF9F7E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1FAEC1A0015
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:31:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PKfFqG5p;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761823913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8L2K4glAjS1GqshDxIkXSBI3ibLLM+9vmuAYmO183Hg=;
	b=mayJLXPefROupgyltdba02CM9+nUpMPtPZ7WxYFArrmwn3c8ZMacvhaMEXehUu/pPzi7/a
	hkNCmXILBQLjsiMfP4xg68MJ1nQTwkPEIY+i9vjWyYbvWRPfAZwMDNMduwRSdbn4XuYBkK
	S9jitwAPzB4h69HmuJheBL6sQDdQNJI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PKfFqG5p;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761823913; a=rsa-sha256;
	cv=none;
	b=f2P+/uWO48E6flJwNZ9YxwR2Z2GdGWD+lMOOEA4EgDtMt7TsxdEi4//CMIysYOp5vGre0p
	/gsA2vqCiwlN/y2nnBvDV+r40Y4B91uhH9tJj2HJ9J01LaYd8jZKMgjNEBZvK7MX/pKxiq
	p89rb2OXUDlI5MIWazm9wyt0rba+3UM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761823912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8L2K4glAjS1GqshDxIkXSBI3ibLLM+9vmuAYmO183Hg=;
	b=PKfFqG5pRb+9vs+fd+M+QmAeC3E1l29yhI9jeYwMsVB+E8b+RBrOkKNHIr1W3M4KwbA5ZJ
	BtZmLRz7xcIYx9HICnMHDa4OaP68f3O+9fKpymrGvI1DOaCWEnn2nJVqXQHhT4S/ypNMJJ
	ttk86+LL7xRDKVHrpKRpF7bBncXckw4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-325-p38bDPAgPi-tg1tuWEQUTg-1; Thu, 30 Oct 2025 07:31:51 -0400
X-MC-Unique: p38bDPAgPi-tg1tuWEQUTg-1
X-Mimecast-MFC-AGG-ID: p38bDPAgPi-tg1tuWEQUTg_1761823910
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-429af6b48a8so1126671f8f.1
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 04:31:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761823910; x=1762428710;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8L2K4glAjS1GqshDxIkXSBI3ibLLM+9vmuAYmO183Hg=;
        b=B01jvbU/1WegjTlC2NkGvah72HwovOdPH0U/z89LFIgMPhZ67IPFa1rmx9LX13Xs5N
         7//OpLNWB52K5e497HL9PMujafi7YAGvItFMzghyJMEIwDy0b2P0aegTUOJDLvmvqoog
         5OyNpv82eTnkmGmu0zkpIcRQghQoacvotKcrIs6z0qkI8p4E60IJ9TDBWNydkDG8N+LT
         DVRn5x5oPkypc1isD7dmB8RTnoGphapObbcq7OfY1o9GP0LrXkRcurEE1EYCikoZlsJs
         +q/D7W6tGvGpLyrGimjT3T/EW6zyyEUSjJq8Vg4GK8EbUXcHJu6d8ox4hzvoM0qoSH4S
         uXkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIfaDoeW0+dPZcmpiIRoE23pLrbXxJhnkoz5jxvPb9mvpcfAsS8NYLGH0zltWLR3fm6w+rV7qvKg==@kvack.org
X-Gm-Message-State: AOJu0YxClXtfxZp/sMfiTdq5R7Wo21ZWibyNDnpEeI+CHZta8khN90TA
	BRVILlzDkvzzvjqH6Qw86Iw9XX1fh7HlvvRgmCmVM8hDpJU6egknyD/yfZNcxBtnZ8ZUG+2svKq
	9RhcyHVuEmMjRXD7Fas+FO22ucHLrJ6Pct5w6M450V7bqChv+3PoD
X-Gm-Gg: ASbGncvAnp/VKy6I4nmKu15VbP/BzYvDCdInAE/OYrrtbHOd4hudYJid4HD7PfN9bQN
	xUGXM/30eXhpfNG9IOTsT8aXW7vlWIEiDaivyEJcjGLv/MRRWNC+XDI6MDZBc71JwvR9e92mp9m
	VubF8FP7YSYJrb41mcLuDZeflXqpN1nf6lK493iAjKwTO/GiqKsoycBWQ179rrmE4DThbUwVrwJ
	z5TW/Suki1o7lbJvMsJ5VVJjJN5d4nyn7Q0Im+9NbBMuyIayJPGDSaRZ7pATvHZYwLLz11rt+0/
	vI63do8BW3UsH6yl0/gGUAKlT9sf4l5pL68YVbxlkYW2r4GyCYQUPrVGMxtSOjvPxzh7XUG/PPc
	wDIDK0hzjb3YOWQEQfT9PVP+nTfvpg1KpKQjAQKhtwDZmfyxHF1vo2PIJWzbJwsV4iEPi8QqC1i
	WPrZ8jDfO6TYxfFImR6vJzoTp7ngA=
X-Received: by 2002:a05:600c:190d:b0:46e:32d4:46a1 with SMTP id 5b1f17b1804b1-4771e1ccb50mr54756155e9.22.1761823909753;
        Thu, 30 Oct 2025 04:31:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4zDUx/D1/Z6VhmjEoFZOarwA+Tm+Yvivc7XUkhwgC06MG9b3q83kkfe9dSmDylYKPgnQdnA==
X-Received: by 2002:a05:600c:190d:b0:46e:32d4:46a1 with SMTP id 5b1f17b1804b1-4771e1ccb50mr54755925e9.22.1761823909363;
        Thu, 30 Oct 2025 04:31:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477289b0bb3sm37898235e9.8.2025.10.30.04.31.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Oct 2025 04:31:48 -0700 (PDT)
Message-ID: <0a241e85-82e8-4053-ab2f-4cf13ccc5892@redhat.com>
Date: Thu, 30 Oct 2025 12:31:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm: convert memory block states (MEM_*) macros to
 enum
To: Israel Batista <linux@israelbatista.dev.br>, lorenzo.stoakes@oracle.com,
 akpm@linux-foundation.org, linux-mm@kvack.org
Cc: osandov@osandov.com, linux-debuggers@vger.kernel.org
References: <20251029195617.2210700-1-linux@israelbatista.dev.br>
 <20251029195617.2210700-2-linux@israelbatista.dev.br>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251029195617.2210700-2-linux@israelbatista.dev.br>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: btdmyt4Gh6_86hmu8y7Dz-gbF-vsmW0IZCk9L4bUUPA_1761823910
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: saiyfw7crem1gg4dsrf54rgaqyydh1wu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1FAEC1A0015
X-HE-Tag: 1761823912-338890
X-HE-Meta: U2FsdGVkX1/boaqdh7Xi38C/LrPB7VFszHHzvHpScR7gjHfjISOPfVC3DzQoiJoKwg9T8weoMrpbUNyroM/ynkSqEhAd9YiNrrGAPPhDAwQNqwLO7urwiBkcnPNqNv5/hAFGLGg9dokRC+5mZRVNv/OiA7it2Ecn+rxrmL+AgYVVubhdo41bqLDQ8PblelwSCtaUNQtR9nA7rh3Rug3psFYbF8xh4ZSkLTxpI9cimQ3nvTIUaydqaWS5z2/NOr/xXU5PpmvzzER68R+a5MImPgP1m29mtGA4JzR9Suvq9mmjQaz5S7SQttrvV8Xt5Il0vkG8H4JKfhCutuO/mxSht/W2JlXNr6xXRHRRocA9RGoV6MNvkTvtNv46PIndAk0ID83QwOeR3SFTni5aZjmdTOMEC9n0Ht22Zjn93K2pYEg9MOckwCOfXCKMiK47kB7lxa0DnFMncS+bJJsxCec4lwp1x0BBEGQQYa6SU49hPAR4rrULIZo+aFbZVpTU0cgW5uOeHVNd7sGEMpthOFsO4dTZ9l66540/GWx8fAR+47p8l9gywco9yup5P+6YKaBqJMIPr9gYlixM92iogWlhwkSA93bO/k7+tm0xk6RU3stREerDXwpnFwj6oZWVSKaniDRt97MQoJ8RVXnuMtSc2xJJCh3d40QlQwjOSo//eDmY8ya506+ejPQtEGWFToK5Qropkj7OHyIbQ56w2gIfqwJ/Bw3dUbdzntgM++IWaf72tAuzrbzUGEv9ASEEnzTCa/f9F1U92lLnj50iEhHUI6ooG4Nh/03Tm1KA+2BoHHrnshx0i9D/lkaSJSkV/9N994gF89sc7AOizwNKEJgEmG/ZMYjgrJ40P+9HtwzWIGeKY3Imu64rpLlyKUPRe9/pMXwAlLCN+K0UPhfo//M0cn3gCij3F2fEof6fF3YOIkqLRoMHwqp9i+oC+zpSMjKqU4J/6K95NvC4i5VjJQc
 eC2YobEu
 5rVBWgOnQlqeOBq0oCG5tQjKpCueLMQuG+Whdj4f4mEQahvl53++7pRzZulLp7A/Y/P2F11PV0FYTuYbrlTs4DCDNHEtxDc26ru3nYsAx7/GE5Er7BnRRLd3S09qGfGwRrILVgz/u/DJZ/vGGItBcGaursPifaJymrL2dDhjP3JtPM3x6od3xNApD/mMgf86J/CHQMIdJ4L1emmSCH8lVCmmbob+J1Pi/t0s4i1WmG89hjBxZpLL/5KUek6TJHvsAzVtQ3C03Hxjts9+A0GCerlnIcRzA+1ClvVNe5LxHnKgHLRAz0C9Fw4r77yWU0imMCyysspcphTsJLn/MO2rtq2Hpj3Q/WQxioYulOtr53K3ai8iTrug1iCSFIT12PMfM3PTN7cwUAERK86HUFDDtOWVdBjb2113oXHHbr8FKetQ9LhQQ+MVMKDly+mQOrFLIF2ofa65IfnnQfihqZ/jo3w5t9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.10.25 20:56, Israel Batista wrote:
> Converting the MEM_* constants from macros to an enum ensures that their
> values will be correctly emitted in the debug symbols, making it easier
> to trace the meaning of each value when debugging with tools such as
> drgn, without the need to hard-code the values.
> 
> Since the values are mutually exclusive and they are not exposed directly to
> userspace, I also dropped the misleading pattern (1<<X) that made it look like
> they were combinable flags.
> 
> Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


