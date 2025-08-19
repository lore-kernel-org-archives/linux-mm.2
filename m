Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A035ECA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 07:41:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286B68E001C; Tue, 19 Aug 2025 03:41:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 237828E0002; Tue, 19 Aug 2025 03:41:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B1568E001C; Tue, 19 Aug 2025 03:41:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E80F08E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:41:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9EA9FC02C3
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:41:48 +0000 (UTC)
X-FDA: 83792712696.05.2E93169
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 32DF7140003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:41:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FzPygK7Z;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755589306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmtWPp0yQOU5JxPYnS+WOg3Vcn1uX2+BI6vYu6deLHc=;
	b=j8ClykiVME5f1VpauEQmSLKf1O7kxr0e65JMIS8rKtOKb5zh9sgnpKQC5pSeVlP+Vjx5Is
	g0AIhTiMxIwiNIm5oT3CX3ymO7sewxHOz+MEERY0gyvNTJR82FiKNPwX1cU/DAA8ubeig9
	D9daIPOFhD1rFE5n8jP8qxRrhmyO1L8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755589306; a=rsa-sha256;
	cv=none;
	b=UIsOYmGbO4cmxLA3kSHZEtCU/X8LjUusC10i3UTM6+F1fLpiMS8/Z1jyY0/7oh75LgH5jv
	WyqPPEX8FvfHqaJXWhwZNUH8sNt3dl2KBrxKKDe3IOHlrxNrI+O87Ryp0ewNCxVQDCdi1/
	AHb6Em0Cp0cKNIPTBkaccpOgCuFKeFM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FzPygK7Z;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755589305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KmtWPp0yQOU5JxPYnS+WOg3Vcn1uX2+BI6vYu6deLHc=;
	b=FzPygK7ZwVc7gZOnIg83nOFRLxX/gs74HK6Yz/mf93UTQ4uR+2doaKma1FMaSkP3ownHDs
	XUlft5J250p4XRGY0c2dGE0ROr/OURRbrskg5blnI35Xn9o2MvtBbrqcjX7X38dyh/iL2g
	MF6npRUvET6TipXZNwaRg1SxswssPW0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-KFZdFxlONOSLJnizjYaO8g-1; Tue, 19 Aug 2025 03:41:44 -0400
X-MC-Unique: KFZdFxlONOSLJnizjYaO8g-1
X-Mimecast-MFC-AGG-ID: KFZdFxlONOSLJnizjYaO8g_1755589303
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b00352eso18106515e9.0
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:41:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755589303; x=1756194103;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KmtWPp0yQOU5JxPYnS+WOg3Vcn1uX2+BI6vYu6deLHc=;
        b=KNPNwYe/+1S4PRra13LVCXGr8uV3d/PVwoGry/ujw458XPpA9Nmq45DcVVqtMMaBJL
         D++7tJzk/hbdHFVPtoZ3itpePkaz9INAts3Xvpqs95olYKYeHrdUybM3dvd35oJehB6a
         EZ9ElqOkX3gcgmbO69xU4P074ZtxQ6qaAhbMiT6h/77jDvFhscJcj8ilFf1D1bYMgHET
         RTH5Cy65AXNENRJwyrtgY9Dn3zybvacBMOH3UBCD5SnmQnwJ0j8CYGy54LWcilpOqgqb
         zI9/4AWSjLKXSdR0PuOoLb9q7Mfzp/W7JqVVOdACRLqxaawohluPASSKDZops3GEtLZi
         7kkg==
X-Forwarded-Encrypted: i=1; AJvYcCWVg9qkiiX0UP1YVBKAT9LPHpr2z/9DPg7BRdv7zD6iqkoGCMI8TB/MTtjpqANQlNrsDL7Z5f5jhg==@kvack.org
X-Gm-Message-State: AOJu0Yx2z0YpymPQ66HjKxLerN5iyqVRGOgKbVYUThhq37SoVc/HJP+X
	sSUqqYTKfAbUE80/jd8AmJEuwZLpSraBApo673kr9nAD2CYHHTkrvBYKmWpFTH8bk7ZfNXJ7WBM
	vobfGK5/HRVdqDGx4Gp+Ha849gRXhno15lhPToLH2dirNRr4297zZ
X-Gm-Gg: ASbGncsYNABkShs04roEcCR9gsCMXW1KZNvc6LWbuq+93Mxw20CbrnMKEtRSlw8SgrT
	JFo7bJFoQankpsB0+86ZEHGzBPDOzcbWzhEhnlP+n5ehabANE4r/Ch6xQR1DqAcUGbJPl0TAqQ8
	Qacsb34JYqnQqL+Qr95IQR+x0MvH3IYRfrC+vAtcN9x8BHvrBCOHhpgTo3WQLbj+UFO+sUUOtPz
	SuTB0MjsWM3BspjLsqp1kHQTJ6JC/oJY07XyHPRiBbcGmp1Sqybt2bIe/V4uVV1ZvE9jXyJyNrI
	ZthmM8wAoN+01/fIsBtbVayfvvuNiEMOLeHDmyPZKo9+7YYE/uIwbECUKuM4CGHGYDtKBkpO1Nu
	cY3bjXyqbI7hU3pqNSLuRS9zAeDvxtws1LMhhmzPcRXhxgyt9aRttv17Wb3Punl4yefM=
X-Received: by 2002:a05:600c:3144:b0:456:2212:46b8 with SMTP id 5b1f17b1804b1-45b43e0bfbcmr8695275e9.28.1755589302922;
        Tue, 19 Aug 2025 00:41:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG35zJviGwvUkWVod6LeZhZp4n0OP2P4yeQ5cLqpahPhuo+I3q3qEllQ2PjejXopYNiv09LgQ==
X-Received: by 2002:a05:600c:3144:b0:456:2212:46b8 with SMTP id 5b1f17b1804b1-45b43e0bfbcmr8695065e9.28.1755589302398;
        Tue, 19 Aug 2025 00:41:42 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:8700:71be:5385:87b8:5a98? (p200300d82f07870071be538587b85a98.dip0.t-ipconnect.de. [2003:d8:2f07:8700:71be:5385:87b8:5a98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c61a66esm201863575e9.0.2025.08.19.00.41.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 00:41:41 -0700 (PDT)
Message-ID: <4289fc02-8e09-4d33-a4a1-0e4b268b008c@redhat.com>
Date: Tue, 19 Aug 2025 09:41:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64/mm: Update create_kpti_ng_temp_pgd() to handle
 pgtable_alloc failure
To: Chaitanya S Prakash <chaitanyas.prakash@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Ryan Roberts <ryan.roberts@arm.com>,
 Yang Shi <yang@os.amperecomputing.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Zhenhua Huang <quic_zhenhuah@quicinc.com>, Joey Gouly <joey.gouly@arm.com>
References: <20250813145607.1612234-1-chaitanyas.prakash@arm.com>
 <20250813145607.1612234-3-chaitanyas.prakash@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250813145607.1612234-3-chaitanyas.prakash@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: d3C0FzPzetipQENYdq9AIR0o-MtHHW9vFx75vC75YEg_1755589303
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 32DF7140003
X-Stat-Signature: 57ofsanjkttswx56egqqme4dbh6o7pag
X-HE-Tag: 1755589306-342397
X-HE-Meta: U2FsdGVkX18c+KysIaN26MBfrO3ZmEovQuTyXvDB0yjuMSdI1eY+A8ZkgUmfxrV7MWD0mKlnXg0QplCTRfU8zOaLGSlEXREwNtkOdss12hlWk4Ut2FUcxm/IYPiu4zvM2HYh+AO1m8UzDwYe+Z0J907+4SLjU+g/euFenQie9RIxdzHmkGkVGU1/RrVZbhVZQn2Z1MUDqEOdQ35/7WMqGkO5yU31jIxb/DuDlOnpcx0hMT/9aFnAeUM90uEtA7+DPGh1yoACrzn2FfsF8v5c8TOG+CBz9DOC1mN9IO7Ud32evK/oV9nx1wlr/PzRkcndZW3T//lJ2QTkee1g23C05ytfr+VTmY7vdll2yYrlFYD9S1RlQsuP7CWw9ovxpw+Ef7eLXNPdwud7h0BaSkPC+/dBqPMZCGZZnLDUAZVdqtgoQd/mrsxZLm7rO5Th4dsvjNqUfRzOTkI2tRwnwA28qadaUEzpBc0plZUzrWZ5TOvZDEFh5KNFIYqB86j1ig68FPxlY+piZC8tqjsziu5uDK01LyG7ostQuY9GcRDZvcOch4+/85BC09d84SxRIZauvvva1sdgMOhAXFRrqRStZcA+tz6wYInA34jipHLFfNO+ft0CWWrHg7C4NKoa7ZD8GNDWkmgs/ZGVam6OttDiphjW23nbKl3oPtolNRYM2qvd07ZiMVW05YPO7D23BeO+g8I0cuCZXQMV3go35SCYgY7HQ8fIYFjGHlrkyzI27vFIodo/0FrXTz0KU20MngxoaNQTUrPAhnHwa1EY3yNnHZZlsFnFxtrlmK7G8B9J/PQYBMTjcdddI3lhg+LMknvQ+9QG32kHUBDzWgctW1amm0U1Tm9mB7HIcsqZi+AuDgH3lbsABh7WpVRuzv9uGt/IC/7yS2zKCcxV0ZDX41EiVTvjSWN1qQO16HVSOecfYEZj4TAsFBLpX94uEPTAkqzmOsppVvgd28MtGqum3v/
 s5xDuW4s
 jYS9rvQsSVrBUC2pg1HZFIIxJQy+y2voOzGMBzLirfzDRPohA9IFNLDwLsXXxrPQogacJheaRpLwnJw2Mard85DslGCSZ4fMF4HnOh3yNrRXInbSWDNAPE0E2QqzsmZPvmU341RCRfJbd8GY1SFkcg1gSX0lN+qC7FEdsnaWsiqHl/CpGxTpfjZr9Vu9dmVxQEFJRDUwH/q+k60E+i0wKS+h7uI+5He7HzxNxL0vk9FQr9TO9L9RehfARCNv0fwHv5B5wXuLsO5LL2T6ixSp55BDwdjOqlalGNMCFF/0pEQ5T7VqOlfukKQFh7fdS8dN9C7Dl/ByyB6TtOWmZJvd7xByebyclGp7hVLY3W6Q+aSgBxH70iQiEGgWxSjP5ejOsImOxLvPg1FO74Hi8HEa0RihZIc2J/rI5IxMjJsCtOwWHzoXNrDXwbhFz48lMSqYwnkbSjW73M2UrMZMGqifMbMLyVi/AKGG4pwfs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.08.25 16:56, Chaitanya S Prakash wrote:
> create_kpti_ng_temp_pgd() was created as an alias for void returning
> __create_pgd_mapping_locked() and relied on pgtable_alloc() to BUG_ON()
> if an allocation failure occurred. But as __create_pgd_mapping_locked()
> has been updated as a part of the error propagation patch to return a
> non-void value, update create_kpti_ng_temp_pgd() to act as a wrapper
> around __create_pgd_mapping_locked() and BUG_ON() on ret being a non
> zero value.

If  my memory serves me right, panic() is preferred in such unexpected 
early-boot scenarios (BUG_ON is frowned upon), where you can actually 
print what is going wrong.


Which raises the question: could create_kpti_ng_temp_pgd() be __init? 
__kpti_install_ng_mappings(), the only caller, seems to be.

-- 
Cheers

David / dhildenb


