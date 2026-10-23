Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9945F60A2601
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 12:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=WEJCeGrs
Received: by kanga.kvack.org (Postfix)
	id AC2616B0B52; Fri, 23 Oct 2026 08:16:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99D96B0B54; Fri, 23 Oct 2026 08:16:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962CC6B0B55; Fri, 23 Oct 2026 08:16:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 61CC86B0B52
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:16:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA2D9A0002
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:16:33 +0000 (UTC)
X-FDA: 85353789066.22.DF65901
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2FF6020010
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:16:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WEJCeGrs;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792757791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0xb8QBiYlV8bc6lTF32H9FrLD4GTaXT902tSotGd5HU=;
	b=RpZH0Gs6Z1ft2ok9v2mKeMNFtAWhCC016pBJYbf44kbBBNY6QZ+HRJv1EOCYh0AykP1/x1
	v6c8jz4CH/2MGCWW7s3ngyu8i9Dh2+BLTL/zW2J4aSAnNUMMMkuRAD6neCf2lwWVUPv09a
	Mnfym7NxdVuU3r+AP7+9DTF4rS3gp4Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WEJCeGrs;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792757791;
	b=5sax1BuZ7Nsg604eop8+yNNKKZvzrFdT/4zWbSctHlPXWL8pp5/lUPwzFfny5EHq01JF/O
	9QWvfZ2i0Qy43MXU9t70F4674eZGJVumYgsl+6oPBGlT70/RcG/u7m+UTUnxUHG7cYMczx
	QqwPlEbn/rRhR47Meu3T1A8zBdsVRn0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792757790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0xb8QBiYlV8bc6lTF32H9FrLD4GTaXT902tSotGd5HU=;
	b=WEJCeGrsDkR2fsm8lKaQawGfjk4kWXD0zQWb8Ossa9vzFo3h3aWcElSA/rK1pPG9p8Ik9v
	3DDpJSikc/i3GTr4+BE797Up6ecFi/zqOSrBA3NY0kKbIJdFTt0sSSYyazcAGPF5e0u3Dp
	fjXMXcIVRDk+TeNfMMTxAHrSLRbe9I4=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-rCqCvQ36MQSQnHgcwsoFnQ-1; Fri, 23 Oct 2026 08:16:29 -0400
X-MC-Unique: rCqCvQ36MQSQnHgcwsoFnQ-1
X-Mimecast-MFC-AGG-ID: rCqCvQ36MQSQnHgcwsoFnQ_1792757789
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-91b7e90fef1so38358686d6.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 05:16:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792757789; x=1793362589;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0xb8QBiYlV8bc6lTF32H9FrLD4GTaXT902tSotGd5HU=;
        b=j5IjL42a5OQ4jh4UPAB0bDGLFsRt7iAo6i9hG5MFunMd4FPqWAtGZhUI7aX4NCadV2
         HWqOMO805dyoRIRfGUhAkh7FUbaEDatzRtG5C/vW5Pe+rlsJd1eaE2Af0KOIMydb1ygi
         0k+DCyrBYdRbJFe2YkNhf/aDHIpXj4+g8T35Zd24glShKgrOf1SO/OcSxAVAl1IEsSRm
         Ac+dmFqiFcFYZM+JPaBlRiH5J74wXQFc20M4ObpagDYtjOktAjM2MVvNvjzs0uyY6RY8
         Fz11vXKQn27FzxtUQ+K4zkq9ijK3U25tkBoLVBVN4P2ES0AiRyTNlSzaf5MMXL4FCEjC
         CsPA==
X-Forwarded-Encrypted: i=1; AKwUvBypg2Ljkcq0dpxllXn26H7IuTYCU3M6gC6ud0Mu2bRCbwCeRXZAfVGCosiKrvIx1a8P+m6z8aiSuw==@kvack.org
X-Gm-Message-State: AFq9FYICHTP3mh0RrrzSRSKPnDR/iNWSTvxTruItM0ZqirPIHGF14rq5
	m0CxIu2CORkAo7Z3GYNNNeN4c/SXPXZCTsDQl4LiH6YpLS6UqM3SXsH3lFBOEa+CprNou7YSjxM
	B5IRXdu+5Jm8pFvIqtscFq8O/ujTFq7304Dxph6uENNtbroxOUhP8
X-Gm-Gg: AYBFou0fql5QT0n6yDqkYXj1rc5REPNvYwGh4kBePcL71HkENBrhaTfbYv3E9+koq0V
	bl7ZCrVATgVegdUbqOQJT+CpbQ+gU9TerT5d+zMj+ZkKlmc+B0ElRByYPMfFdEEBA5Sy6bAkA9z
	3pZvBFHAdp98Y9OSYCtUVDLCaSMULEdA6QDl0VsY7RqtFacKoG/bnT/FTAdSBwE0U2eAmudswcu
	jAGwgnatun5NlaNTmB+RV6Bp5hTUDiS3Dzi1GCUESMxIseIsFbPq2R7BQOPNFU13irxzu7IUjcG
	VpWQH4kgEwWKtxFWlHJ2llex5RWXKFEmfBaXWE2glt+x4fCGIuYz054dfOZMg6cN6lHeBDByUWL
	Cdto=
X-Received: by 2002:a05:622a:a884:b0:535:52c:a2e2 with SMTP id d75a77b69052e-536c28b8afbmr21946051cf.20.1792757788544;
        Fri, 23 Oct 2026 05:16:28 -0700 (PDT)
X-Received: by 2002:a05:622a:a884:b0:535:52c:a2e2 with SMTP id d75a77b69052e-536c28b8afbmr21945551cf.20.1792757787980;
        Fri, 23 Oct 2026 05:16:27 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536c18b0e2asm14855791cf.28.2026.10.23.05.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 05:16:27 -0700 (PDT)
Message-ID: <50545ab3-bf06-456d-8d14-2536f90f6f65@redhat.com>
Date: Fri, 23 Oct 2026 08:16:26 -0400
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mremap() fails VMA expansion when VM_MIXEDMAP is set
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>,
 Jakub Matena <matenajakub@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261023023106.515365-1-luizcap@redhat.com>
 <8c53e58c-f7d2-4e98-8d03-7ff1163c1159@kernel.org> <atsYe34Qvw5oUDMZ@gremlin>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <atsYe34Qvw5oUDMZ@gremlin>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NzLjhECl6qr-uqkPQXAGYSfs_YOWTpDTb6TN0RX3UPk_1792757789
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2FF6020010
X-Stat-Signature: rbinrgnes1ysg13xexd35sopt38f8r9g
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792757791-588897
X-HE-Meta: U2FsdGVkX18EZQyBBDy2AU6gk/x72CjpJCtGntDgfX2e6vut92E/WemcVbayBvi/80+fPwzQaQZxGVjatkD7veIuy41kP3cDSSn87RmPbVFb62Kzu0+UtVPGywusqXbBCrdbzhKnTiuOgfqVu+y9DJ5MqrYgA3dVz0Lf4xXpUokP7VpFMu7dJrSWbP15dF4pVrXea6/qx+7N5c7IRXcDEBdZm5dISYABWDMJIkb9PZ2bMTmIJ8Dbw1vyX5fF+pqVZL64em2sNSaByZm7b/0HAWgJce/hzzJdBNG5zetaHD/+Nb7tJ2SKvZpBuKWq2xVUN54B9/xQO53WcHecmUD4iieUT8HYyEA7RYt9+1VvkCyM61ajw5WC1pXBvrleUgDi4qNd7i0ZYgCr1WniclKUqbDa7tpDer0F8XXNqi1HcFcNhr0+qs6ql/qy13s5U5ujzJWYI02RduJAb3PQiWbuPn007rPTtFU+/siG/3bo8Uk2ncY1qnYbNirHtqdT/Hl19D3VVGA6wk9z/7Tu7BcOSWHtdsOoUXJjMgqc+Q+u6yzUAGU/puWVcTh+u3FXHVrHuBEwy+VCWqWvgpYbUlQ9aroeEYI2GqHIjokTQ3JJYkMwNV+C/3ltrT8UZkEtK4f1PNlLxAQEIxYvvO6XyMk/+Jz9RMDCurO9Did4kwg89Au42Hr9hPbFews2sj7vedXd1uTFfIJ2S/WbA1mj4KSVarh6Va+fqvODVSqYXt9/qKzclqgJTV47qXt2ueBWuXCDZYzaIFpIehmyl0klKkvdtO/F4vD2z5HjQsx1kGr2cb8REtu+RTfR83dp6Fzv3/9P+caRi3d7QJBw1uEI9OVS9Bwo0eTJFtAOSi3tPtR0kTSAPZA8QkX6aqIQs+IdzEvgFY6VuYM+czesODPxKJ9Rwmyo6jFAv4YfhjuEYICH3xASyoDJVVW/5luR1bdx1fdGHih686lcDdmIsrypTOO
 CrlG8PYx
 /0XO87+HP/MZTOkrKp505ccrGIn8zzMEplB23yWqAhXZtQwKH1zetbgjN9CbtP8Rbsd8QCrOdziqMRl49+RkIQVyy/TrpqLo3UT73RYeGY0rIRV3oD85/LGMR+45Pl6b/sFedqyrowHQRFyzW/4qfza7AEiqCbXXlE45HnpZxrFIlcQ/yu3I+bknghUSJwmu5wWW8MUcGhssBNI2jbwXPpmfF8p4Vm3ON671oKOeSjDb1li8ZK6zO0n28j5cOkeTxrNKVq6CRzH3B/URP/6rZhFulD5gweT5MDcFhHXkPsVyy0Gi/Q61L5FF5rmrJqpcJZdiuNErd3VKu4Xn+XqNRRF0Y7BwAxWbdJCgSJW97PA01m1YYE4PXi3YS16j0u0LwIyzt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/23/26 4:19 AM, Lorenzo Stoakes (ARM) wrote:
> On Fri, Oct 23, 2026 at 09:16:12AM +0200, Vlastimil Babka (SUSE) wrote:
>> On 10/23/26 04:31, Luiz Capitulino wrote:
> 
>>> This regression was introduced in v6.1 by commit ca3d76b0aa80 ("mm: add merging
>>> after mremap resize"). This commit changed mremap() to use vma_merge() instead
>>> of vma_adjust() for the expansion case. However, vma_merge() returns NULL for
>>> a VMA that has any of the VM_SPECIAL flags set.
>>
>> Hi,
>>
>> 6.1 was a rather long time ago. How was it discovered just now? I.e. what
>> use case broke by the change and prompted creating the reproducer?
>>
>> Vlastimil
>> Thanks,
> 
> Thanks, I have the same questions :)
> 
> Do always include that kind of information and whether it was an LLM-discovered
> thing or whether you had an actual workload that was impacted, etc.

Will do the next time, I claried the use-case in my response to
Vlastimil.

> 
> --
> Cheers, Lorenzo


