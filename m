Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7593C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 14:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D58996B009D; Wed,  5 Aug 2026 10:49:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2FA06B009E; Wed,  5 Aug 2026 10:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1E6C6B009F; Wed,  5 Aug 2026 10:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 991856B009D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:49:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 297C21604B7
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:49:14 +0000 (UTC)
X-FDA: 85067498628.14.96A545B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1F85F40004
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:49:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i0kpysDp;
	spf=pass (imf17.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785941352;
	b=fJ/14Ti9BXwwaxs8nc7GSoJExWwHuu+uJAtOC8TQzgGc8ut6ZA1DJlsJxujuFBA3B0DXmq
	85l0qPU8sq0nBTzTtN0+R2I2xqE5Myl1zSefucAcqQ88h68OvMTBefWM35946CXWc2tOd3
	hRQTQP28B2KNAGwgp3ovNLVSzpw61WE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i0kpysDp;
	spf=pass (imf17.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785941352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1JhdEbvWEhrHfPPwqh3xlPX09FvDSySuhPj71HiPhw8=;
	b=YPZ/2dBKmQoA6YRa8cKOrVya4e1AnMWIOtXNu4ASa8MsRIB9CfukxtG20c3raLvDo/nDxA
	jOn+jPjDlVzOpGykFEGK98wVGf9kSHU3FMp2XcoZbmn/jtuK5SXScNvxOLApefjsDVgL5b
	HgdWeXYVkN+9mfO2gNR89a2AMo+gIbA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785941351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1JhdEbvWEhrHfPPwqh3xlPX09FvDSySuhPj71HiPhw8=;
	b=i0kpysDpqy8KNyfkFw3R0iFXqG/j/un8sxPQlBCMy74Pw6scj7vSZCiK6h3xpSpGH0lwbX
	wSGwrG/6Yx/nE6eA43M3Q2u2qZawtQlxjra54gFV2wkm4Dc+KjDImETyE87FHdI6VRRPT8
	Fo3xeilryO2swgZR5P5i5WaUq8xmwSs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-660-ljrUInx7OHWIUGmNcJXrYg-1; Wed,
 05 Aug 2026 10:49:08 -0400
X-MC-Unique: ljrUInx7OHWIUGmNcJXrYg-1
X-Mimecast-MFC-AGG-ID: ljrUInx7OHWIUGmNcJXrYg_1785941345
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 681D11802566;
	Wed,  5 Aug 2026 14:48:59 +0000 (UTC)
Received: from [10.44.48.18] (unknown [10.44.48.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 617CF1956041;
	Wed,  5 Aug 2026 14:48:51 +0000 (UTC)
Message-ID: <12bd995c-e320-47c9-adb1-fff3a14bddc7@redhat.com>
Date: Wed, 5 Aug 2026 16:48:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFT 3/3] drm/ttm, drm/vmwgfx: directly create writable
 PTEs when mkwrite is in use
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Hildenbrand
 <david@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Sergio Lopez <slp@redhat.com>, Huang Rui <ray.huang@amd.com>,
 bcm-kernel-feedback-list@broadcom.com, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org
References: <20260731164341.1109827-1-pbonzini@redhat.com>
 <20260731164341.1109827-4-pbonzini@redhat.com>
 <c1652ce8-0b0a-49a1-a842-bf1a5290cc1a@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <c1652ce8-0b0a-49a1-a842-bf1a5290cc1a@amd.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: xXzdpKLTm8LxFgc18pYyBvO6CvauZsb_FJS2_rpIAK0_1785941345
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1F85F40004
X-Stat-Signature: 1rihbqnmw811cizu1c8uffyariqmdtwr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785941351-943609
X-HE-Meta: U2FsdGVkX1/uciiMv4qZnRwQ7rEDh99ETyXUbfRGGQHti+G7dwHCF7k3UY1aaH9undIeh6UDSFf75RiZ93IGYGNdEF6W5lDqTddxOt9bkXTZdQ18+9zU+VFNPcKCoFTvtoxSytYViVWv36rW/UzlP17hlTvYandSwXs+kv+jhaEEYq72LfKnabGQ2px5XfoqpntJz89KbdJ1Ie0xa2Y38X6479YWhcTh4w9gxR8aY5sU+IuPgI2KOTPYm/AxJGUm71ZygoMiezll280VlKcPUQp/k0J3uaWpieCarGbIlHTVqfuBnkiR1kg3FB99yw7mONpvnONRBsM98gmZNhkHi3GJrB90kF4qZvl01RniMFZzbC6ltKF26akLxrMtsj0Z9x59XH/s5oTGzqjyW7tG899Pf2nZ2DL0UN2ml6sJx0oFMrAztgfDoBFHIs79H+87r9XM+a0rN0npLvVo5kRIqsr5N63ldbEAm3nVVb8v7nPjhIpCzc0Q6tiN45igCydK1coHurHEIPZeUb6T+wxuTbUlgX/u6CgcNdX+QaN6r0+2ZY26oWiJaxaNOf8wnQMRuiblyZrpLDERue5W4MlK+T6H19WEu0W37pIzlaMX0hYvSdDvDy6khL8hJOjNF8BLmKRonM8X7oXEDBkAGf8VL6a3rN/qV82Jbf05JkL3V8v2P4vPI0s4jULOmQUQspx1KGK4/AYcdsfO/qXiLQdclMrDGtMtKiWklqhUatLVcoReb9lhrw93o/Yn9utfwNM1zL7a31HbaWVwunONmchp6N1/g3ejOCpyeBfmeK8inGUeQk9q/ClJZXdhOhNokKIzpI5TVSFiUbC5OVVUiHP9pREQGa90mHoQIZblcRxBq4qxuoNjKzy0Z+HTXwjKbzaQFxV/MQIFjmRuQRFbXk/h8kdYgq5Nnut67xxR95uj86uB+qJkPCS+wDn4M1T4RFEOGl85V43c2n7eUWDykFG
 KjEvtDad
 LU4bkbbYQBlF48t3QfJpEPibm91cx81rh/rebrTMjKfhq64iwc8MYKiD+C/3J8+WeG7zLvNjhShLQW+E66fhKYJCMF/uvRifde+SxBTL8mKP/q/1MXKNet7evr9m+9ib7sTJhaQNQBEbQRM+bYVa5TPPp9w5aaEi89TFihGF8vSfeoSVe4WJFo9mloboyg37YQCCzhcrQ9zZIppIvnrNnUxYBKEMf3SHrjCkjbygSZ8bNNVOHNi69DZhIPiicCapiXxkekwsws062bAk9fxussdp3FIGpjlRkKmIvpkDB8ScsdGCeVjQPmNon0tTARF4oI7loy5QhXxQ1N/ktHqVvC9sTClJuZGJUFFcRIWt0z3rkCQBKjbWviZU2xdeDU4n0cikPofpg2RL8T6DM39rPsBAe4rjoUuZzT93W8oKyyeCnrG/u/wjZyJXBIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 14:58, Christian König wrote:
> On 7/31/26 18:43, Paolo Bonzini wrote:
>> This ensures that fixup_user_fault() users see a writable PTE when 
>> they request one.  The flip side is that vmw_bo_vm_fault() now has 
>> to record by hand the write fault, because .pfn_mkwrite() is not
>> invoked.
>> 
>> Prefaulting works as before because only the first entry comes out
>> writable, while the following ones still end up executing 
>> the .pfn_mkwrite() callback.
> 
> Please split that patch for TTM/VMWGFX. The TTM part looks
> reasonable, but VMGFX is a completely different beast.

Note that the TTM change alone would break vmwgfx without the other 
part.  This is not obvious, and it's why I placed them together given 
the TTM part is just one line of code, but if you prefer I can split 
them (the TTM change can go second).

Let me know if "looks reasonable" counts as "Acked-by" for that part or not.

By the way, see also 
https://lists.freedesktop.org/archives/dri-devel/2026-August/586696.html 
- it touches the same code, and the mistake was noticed by sashiko when 
reviewing this one.

Paolo


