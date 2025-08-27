Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97E78CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 14:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 999198E0002; Wed, 27 Aug 2025 10:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94B558E0001; Wed, 27 Aug 2025 10:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 811688E0002; Wed, 27 Aug 2025 10:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6FFB98E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 10:34:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23EA2118388
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:34:46 +0000 (UTC)
X-FDA: 83822783772.06.95859CA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9AC0A12000A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:34:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CHMh2154;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756305283; a=rsa-sha256;
	cv=none;
	b=uf48vPp677gGigUjUvYWm5UZ+WO/pd64Gu8yZZpdZ0jPTlYlSjU23N9YZalCwDxCVeDzuH
	Mzf/boWLTp8fGJPOeKSZIY2B+cG1oNeisSwBsqxjVdihopABsQ8cPG9wEYbYlCu09DtQ4f
	i6SSg8cCMhg5AkeOWcCxX6FsmOLswmA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CHMh2154;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756305283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+6J27g3PzVLwPT69v8xrD/Pf9wlMRrglSVCG5aMSNo=;
	b=yyap1g0O/fSjWZKTuG/RLOrN1doV1P8XFa9+GIDd4i8iTWZTujFQdG2hiHG5Duf9lR0wbI
	DIOUU89T4RStZpITGhr6jDEeGnZcHYk2bAQT24GCSI2bht2ZWCj7OqvM3DPti0km5kWUg0
	VY6oV/Btxc6NH6uHKtFWXxRfoJSfVLo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756305282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=O+6J27g3PzVLwPT69v8xrD/Pf9wlMRrglSVCG5aMSNo=;
	b=CHMh21546hCM4yV1NE2YdMQiJOHm3NdN1W7eZix16h1MPzCv/ewhWMuhs1NfhtnebBLVMv
	9lZM4P8SKcnNc5+jnjZPdG3p6DQlz0JVcMqe93VHXHPUHKHd21Fx2aXutKF4BsL2MkB7bL
	5zyIYfDNDMDOHmWDkPLzBIe8fLbNsx8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-wJBPXSAcNFSJY1ty104ndg-1; Wed, 27 Aug 2025 10:34:41 -0400
X-MC-Unique: wJBPXSAcNFSJY1ty104ndg-1
X-Mimecast-MFC-AGG-ID: wJBPXSAcNFSJY1ty104ndg_1756305281
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4b109c7ad98so239222161cf.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:34:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756305281; x=1756910081;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O+6J27g3PzVLwPT69v8xrD/Pf9wlMRrglSVCG5aMSNo=;
        b=L9PDDXy7nVtECbHTGIKjXFrwmQnQfRrEJs6NRrKL7Y5eOFj8C7ec3YQeTjrHjmAHVI
         c95fGWjRsItjY+8f25647ayzXDyUkURolQjeJeVT8LmC+9TArW2St8GD+rZO4EK29tVe
         XIob8ernhBNOVPNRk7uVXpOXGtNgyer28TULj+Pr4pNj7fnPZz9a05f7MmaLgzKz5LaZ
         4r+5LkR7y4nUYNXxDg4LKw8C8TyhVTWOhMu2g1cRW5nwJvt8m6E5//fwsbYLYC+1Lm6L
         oS7N8zvjnPXKp+nBA+dQP9Bg4TTOh9XE09h3jC/3CZzJMHCEJm6GWVmgNXtcd/Kdn3pE
         aZFw==
X-Forwarded-Encrypted: i=1; AJvYcCWpdead1wMGcBPRb9YYyLaWo0vYiMq8RIIy2+zGVI2m2DQxcHYH+FdvfONF/aPQ4ttyapcpUy/gYQ==@kvack.org
X-Gm-Message-State: AOJu0Yy3zULuVnpmyHDlrHPmnBb0H9/GDENxe1AwvVONNPapux0fB0cn
	YnckNaPxxy2wXl6qzHXyXASzrbdwiaLSZLsCRMhp5Reiwnbe7TE6/Ydym8C7W+tuucWfjWf8ck6
	j+mSptYSGgfS7SZ/9KZyNB7DU/JAWd6xE7Bde2ZqzonFVIGuvfbAg
X-Gm-Gg: ASbGncuK8bwDvGH25o9D+tMwXT8VRp3V623rfk75yiBFx4s3Z4Tz9we9i45G4sN9KcA
	zS0DrFAT/SNcI58z1pJWjFCNiFuH+sWsjnY8jn32gewLLLm/jGgSZQ9uKZ92cs/+kAwcJWWNKuq
	rL1rhtuqTF1VeNE0/ew4xLWXaj5V7N0sg8Jmb3DSvdbnYFTRtaBTvIUJQPLKavDlNkeo2lZ23fU
	z007b5pSZowqyX9qvoxMrO71fyxW0onTKUhZ06uCi6NSMviP0KGzB64/iFsd9LIOqJo2IEk5lsH
	W8ZI8DjqXizaIJixJEr4Xh8ItzIC3rt/tjYwfJlNh3qIPFJrC65IrXfFnxr/xQ==
X-Received: by 2002:a05:622a:207:b0:4b2:d946:f722 with SMTP id d75a77b69052e-4b2d946fe59mr109270021cf.42.1756305280853;
        Wed, 27 Aug 2025 07:34:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE17UoC6BDTwBhYei22ueJMYZMNMRV/5hNaLrpO80gJoTKIKbD1rlCYod8CxcHQ3MIZfR/MvA==
X-Received: by 2002:a05:622a:207:b0:4b2:d946:f722 with SMTP id d75a77b69052e-4b2d946fe59mr109269461cf.42.1756305280316;
        Wed, 27 Aug 2025 07:34:40 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b2b8c693a3sm94776351cf.1.2025.08.27.07.34.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 07:34:39 -0700 (PDT)
Message-ID: <2aa3f478-9c87-4102-b83e-bf235372d834@redhat.com>
Date: Wed, 27 Aug 2025 16:34:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] huge_mm.h: is_huge_zero_folio(NULL) should return
 false
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, shikemeng@huaweicloud.com, kasong@tencent.com,
 nphamcs@gmail.com, bhe@redhat.com, chrisl@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250826231626.218675-1-max.kellermann@ionos.com>
 <20250826185515.7fbe1821713195b170ac1b31@linux-foundation.org>
 <CAKPOu+9wz9g0VuYDPiNDYdaGG-gdK86h1gGSCmVPsC2a5f-GPA@mail.gmail.com>
 <e5783c3d-7eeb-41d9-9fe7-730155f9bf17@redhat.com>
 <CAKPOu+_8_gfko=Sh-YKpbgcMy0aJB=m9yrC5JJKEZm=yeYPOgA@mail.gmail.com>
 <11a5d391-3a13-4376-98f1-34b529d3c583@redhat.com>
 <CAKPOu+9j5+w6ydvygdWnryZM24AFPSVJB_21VH8Odi_xdrNksg@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKPOu+9j5+w6ydvygdWnryZM24AFPSVJB_21VH8Odi_xdrNksg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CO0FgKHv_gVrsVXaiP_hQtMd-983IivToYRR9O-hfIA_1756305281
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9AC0A12000A
X-Stat-Signature: ssop7135i636mr5cdhp7hhwprp1fofdp
X-Rspam-User: 
X-HE-Tag: 1756305283-842005
X-HE-Meta: U2FsdGVkX189YuJZXdvXZvadsC7gk4xNdkCT+MiIrN8YsfaLT6LZVvJupnne4yJoOYfQjy7H3tGvLtStshLlbDOZ8Ll1bNfs5y9SmaRtmT8pNPnNjG0/YUD4iC5k0qZ0nCBglV12QuAZNQBwotbBK78oT1iRJhV+JfRJk32v2/EgzxnYweboqOUiJWM5j9vmdhEhyo+44JbL10DxBAkUCd/9akVZVips9Vv4ohnaGHTW43LeqiuslAjjNd1w3QCdTZ0gB7DcGfZsEi1xIqdJX1BUEO7y3ibd4iL0h0JvoyYZvf+u7SQfJjuSxATSl09zX+rEIgiYnZiwpOVxiFtjbIaOj6Sxtcl5vmEMweHxAzkFja19JWeKCarr9Q/XNZvAnpCb3QlKrw5ejoaLOxqiU03VyzJrp4diIkSqC2k0Aat4tHCEENK8rzk5JuFioQVr31Q4/uwvpE4iGVOWpXW4IOenQ9EdWK08R05e/EjENRSssW2aRCoOabYfJFYWm8YTxFfFEKm7OBcr8SX4CrLN2dbeS5EBtkgqwy0WL45cfp1OAfaSeXUbGcT2AgrooyOOCOEAQLNP9cQ0t59l5/AXtWaLGVa0aMPVuywoXb77e9iXgQM507KgRba+EahZTncByQHucFnqdxv3sFGCJX6JEC2d/j9Qi3MwKuMxy21GrD6V76w3HGRW2ky0wfBB6q0wdRWalrnoIyAjEh9I7bLJEFeQJ/twnF4921bMpaCKSf9JBsLmb9nO2IHIcJXRL2tVGu9IBWYo6aoObG3hSyOT8XXD7dllTAEg11oLKr44HrXxBB3w2zF/tUyPnAC7gaGTnnunrX/xh+TvLjzSJn+a2t0Y7ZC6jTPzJRV0nj1CGOcXOU67mi5NUf5kGC+1oYSbGkfz3nfleho9/NweRrc4fB7gg7pTlB0pvg+HCxEhllZwYhA2Y7zBiegNVGpxNUydk9g4T8T6lzUe6x4ALTQ
 EGbHEpOL
 xUf9jQT9WEEujBaDgbBOCQ9LsXw/LH/nW65vnRA52XfJJmlyresaYyPw4EsTasTR3AWAZ84IcISqsJMoGuVZ4TURGVA+ryVVrTr5rdth7o+AUIf6yHDj1NloRa0M9gImtkUBsioiTdgBEAGOdGqoThMbe0IP/PI2CBpRJat4WA8SAv/JlEe6L/aY+uDhpCnNKJLoytGqi2kkjP94Q+6+kgcQHkcs8/vmvbk4nHEQf9+R1XfLYuJjlj0NbErjnjiVxwCQ49kROCeKP9WOBb41V/wmXfCSNMpZQL39c6eBNNVXyR8LTPVIguDYJ9G0zuVL3PyB3y0NJdFCgJmtIH4DCdcPoKOGFXm8SlvWd5+7lBjXvksubeBP8kPXvmFH1FCvv+0KeHxcc1j9vzZqHt5FzTLoSHxck4KGtmyHDCVgb3lKnMXHM2r1i7vnRnqc8azai3es0EvhkOb3RILdHdm8WuJH0TCwWlpb9IIsG56nj99/OYcW0SpccJ9aAefgOZaMNTIld0AXx6cfiNNC7+AIBpnSOWQSeLDN2bEizRYpn561oJviYRcoRgVyQYmFRGN+5BoQI0+r+kVKzeVwlizbFhorgd7bIecmAsF46
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.08.25 15:06, Max Kellermann wrote:
> On Wed, Aug 27, 2025 at 1:56 PM David Hildenbrand <david@redhat.com> wrote:
>>> This patch isn't about the function parameter but about the global
>>> variable being NULL.
>>> (Don't mix up with my other patch.)
>>
>> Huh?
> 
> Oh, I see the misunderstanding. You are right here, yes my patch is
> indeed about passing NULL to is_huge_zero_folio(). My previous reply
> was confusing.
> 
> But you were replying to a sub-thread by Andrew who questioned whether
> a call is_huge_zero_folio() is legal at all before the huge zero folio
> has been created.

Sure it is, I mean on some systems it is never initialized.

> The question I asked Andrew, which you replied to, was not about
> passing NULL to is_huge_zero_folio(), but about whether the call to
> is_huge_zero_folio() is legal at all, no matter which parameter value.

Yes, see how get_huge_zero_folio() dynamically allocates it on demand to 
then update huge_zero_folio.

> 
> I agree with you that is_huge_zero_folio(NULL) should not be legal and
> makes no sense. It's a bug somewhere in the caller.
> But I saw that the current implementation effectively (randomly) hides
> a bug in another part of the kernel (= Ceph), one that I'd rather like
> to be visible (and get fixed). And that is the point of my patch, and
> is the reason why I chose to have the additional debug-only code
> inside an #ifdef - I don't want normal users to pay the price for a
> debugging feature, no matter how small the price.
> 
> David, what is your opinion here?
> 
> - leave it as it is; is_huge_zero_folio(NULL) may randomly return true
> or false (= reject this patch)
> - add the huge_zero_folio==NULL check, but guarded with #ifdef DEBUG
> (= this patch)
> - add the huge_zero_folio==NULL check unconditionally (suggested by Zi Yan)

VM_WARN_ON_ONCE(!folio);

Should allow for catching such bugs without causing any runtime overhead 
on non-debug kernels.


-- 
Cheers

David / dhildenb


