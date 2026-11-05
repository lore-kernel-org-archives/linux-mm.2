Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A48606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ag5J149Z
Received: by kanga.kvack.org (Postfix)
	id 999D56B05B2; Thu,  5 Nov 2026 06:56:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 949F56B05B3; Thu,  5 Nov 2026 06:56:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 860986B05B9; Thu,  5 Nov 2026 06:56:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 61A2C6B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:56:33 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8571EA0977
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:56:30 +0000 (UTC)
X-FDA: 85400912940.26.7D446B5
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 858CA10000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:56:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Ag5J149Z;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793879788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RAC3JyCcPbrtGRCcu9CD6bbgq1BaxglIl3X5ZCQ3VwI=;
	b=XjSmYThgGG5xY3yFckv5crYBmnadvFARwuIjrfTH77Eyfe/n3a3Cm2X02DSyIPdROcpgzc
	tKopx3ov4QDoppoGtWpEChEbtJGqGLY9oL+LM+yzwNBHDjJyRUKg2h7iJJ+QmlDSSY2Jsf
	gk2mySVJeICWylFvEjV9VFayvCh29wM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793879788;
	b=KBm0/mms1fHr+TmsjQMgtDrVfJ/0s+Xl+QnW7nBaFPm5PqhehGzkwjih3gzQ6JQunXNEHp
	PDnlcY1uPZ1Cq1bQ62oxeI94CYnDEbhmWQdogFbdyLHSCp/ByCklxrdgfWhi8lIWHUpX3Y
	ac6Kreq41nduUXsPJuTu0i6zzkCeqMI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Ag5J149Z;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso11909285e9.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 03:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793879787; x=1794484587; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RAC3JyCcPbrtGRCcu9CD6bbgq1BaxglIl3X5ZCQ3VwI=;
        b=Ag5J149Zuoa7EVrFTM7+4Dm5ihnVawA6L1ORM1uHziDC7w6+uHrlzb7AvHnM/TRpM3
         TdvFost1D0+ZIEOkghjaWFHOh9eqF8Xc4pzT5YIFnNeGsmLG/PvSH3DQmqpv7pnBDhkW
         c+c8SYNffhDc9X7BDFVltwNFntbBRTsThC9P41jqeoVkRTKmGX5ebdqviwvu0REIZMd8
         7atonutgdP0dJFaBzRNxY8R/6L662CInL/5OebSIwK64ltNMTg9ouU+QqPQz+PdwOMUY
         XKk6ZZg5O8quM5ABzdAyKJmZAXWLOM14IkomLwKrViZm42w2csw4vFJbiUczKjzWcJCp
         uuOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793879787; x=1794484587;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RAC3JyCcPbrtGRCcu9CD6bbgq1BaxglIl3X5ZCQ3VwI=;
        b=kRAv22kEidkTap8CWDerWS3mlvSp6ehVcBV2Vtk26CMMgU8yWezBni7IqODRoE11Bm
         OcSnbkjf1DPBHtSEuZ6anagZmr3bP1aN38LzO6H8CeCFioWkdQuSnuzXc3pnr/cGpf7E
         RKf7ahzxFPWcYFEe9jHjZJt+j6K465FslEQvWhcR8vTX+Gy1raQxcxF/MNQNX5tRgdXa
         gkspkwdaUqRmLewyyNQ2fnMYt7Bu/aZrC7DYC8x5+9vtIRMJJdUPd89W2YUDVCuoUqjV
         BK2TkS0+/xqIyKTGvvfu4A4UgxEwl9r1PjKK5/gt6fe/HXTngfjTRTR+NzAQGdxqAeP4
         /mdg==
X-Forwarded-Encrypted: i=1; AKwUvBw9B7co6UMezkw9/HyAmVSZ8uSb1Hv+2dHyGIpuoCPLJcfpd84htw/coRP3ti1HTzlcEEmNnplFew==@kvack.org
X-Gm-Message-State: APuU4Z856VXXYo5rfqlBu7PRoRvH4xxM/gNtEpaMVpJQIWot0l07HIdM
	OKfID4y0UShDjQmoJBrNXGMew1TL9nVEQteJaD1VjzPmijFNC6jKKc80
X-Gm-Gg: AYBFou0B0gV33z8QQRhY1fApMmiOspLAfkJP3MoLfMdTyGyUpN7dV0GnXn8qRRBt0Fo
	gVVopu7fFZM/k/y9WqTtOE5qwigATE/mwaqSLznkKRqRU5PktqxEogHmmX3XPPGAkq5StGf9x7h
	VxbQiPg8f1LRSPAgXnQnzd8cagW08diDdBBvLCknOZjnq80OXMkBQsOPfUeabNKO/LQFAQfQxGM
	ypNoTZfviCTXGN5TJxFQVBxNFyWLBMcpwWggtx65H19SG8d74bF0rKpAM4IoVqqQOzeV9P1cZjF
	ha8Jym5VYwC//RyV1mgYKnYgMXjHLkpARlQcQnR2eg5TuCf/vIGeO8ExIaVtEVUcEy3Nz4XiSGp
	qu4lq+C0hSP8ZZCitIEjPP37v6xZUtNHZK9lw21OZOQ40kcbmYO+EJIwruUyvVB/V0A5Dx55MiU
	shMSNhKD3jwFteFAiotI343XuvYx+j2jl5d0NmlcWgueIEbrnu+zQjQcWzSEJQVoDTbWNroJcOS
	ArkEO5sinC+jP3K3JKj/fXxLU/pY4T7D+5bHuD0plB3epr6RXHsQda9R85snJ3Lq+MFUteGIHjP
	DsKXB/NygTACB3+eOMNfWDKdbG9UWi4UiLJcmqSSo+56
X-Received: by 2002:a05:600c:6212:b0:4a4:de70:2ad4 with SMTP id 5b1f17b1804b1-4ac17ffa395mr398423355e9.22.1793879786986;
        Thu, 05 Nov 2026 03:56:26 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fea181085sm9708651f8f.1.2026.11.05.03.56.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 03:56:26 -0800 (PST)
Message-ID: <d2965cb2-428f-484a-bd81-55b78b770b96@gmail.com>
Date: Thu, 5 Nov 2026 12:56:24 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] memblock: don't allocate new reserve_mem regions on a
 KHO boot
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>,
 Changyuan Lyu <changyuanl@google.com>, Alexander Graf <graf@amazon.com>,
 Tony Luck <tony.luck@intel.com>, "Guilherme G. Piccoli"
 <gpiccoli@igalia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Pratyush Yadav <pratyush@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, kexec@lists.infradead.org
References: <20261104204235.9066-1-azpijr@gmail.com>
 <auw3dtAMp4CjNwY2@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <auw3dtAMp4CjNwY2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 5kksdt396fy9sszfbi6p4zwwfzguhpxc
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 858CA10000C
X-Rspam-User: 
X-HE-Tag: 1793879788-289574
X-HE-Meta: U2FsdGVkX19ct5i0oHEGv2xGwPJw1Z4kKc/p8ZZuj+1eOMtK3x2RSvBaMGBWz/kYHLhtBBlIkTFnUVNKYZRWeNS0dSXrJvN+luxGsGFtXceiXg+zdb+jZeTwY+qtoX4ff1X0SB1bmLo2t8HeGk5s5HplzS7Zo6ShhKMHrIAqaBf7U/baA2bQPErgOr2owAhK3xjF1KdhViqGVPf004vnggM7wosvHFf+GiPSMZtua6q/FzeBAqmHhwGcJWnIdwo5Gex7kJ9+hGQbzwrf3H0iJ5CdWCrmG3MC7Lz64zoPhibM8Dxd7pMyKwf8b0h0BIayOlhnNz7xK2+1QBqARQHErn3cFWhvT/IFU+1IBm0WhR83uQvAM7v4vi30ggDy3IpCYaacenQZh/PvuFT9wGuSmjoCYCKf5J76Ry6uVai15BWMIpoP2pprbufkxpUr5k+HwZluoRvcv2AO2l1N2bx7UsHvABoMQEQiMRRsR2IGXTXDKbfRa3jnvs1RMqR1ZMZXrQ+j0Z2sk0NB2/1MfR48wXubv/SHYAe0KQDlB12ZxmxoPBxhQQr1PdNzFqdJvPcYivaE/bjwo1p4OJQ1cL+gu+T7M0Umxd/H2bY+Djrs2Vg7LJ/O8ON9lO/GI+7FF85g7Pb9RcTpzP945EwPygjuaU6j+JTjIDiG8A/dJu1dKNhOmQTZzUUu7Eiby889QoiyAqwgtFoxuJxmLaMBoRs+KIh4HCpCc/fKnOZ9HfQubxunz4KgblLsuFtbyfA/b+O0hpfEhSYGaRkHovaFLomod67Vw2di9d7YqlkKGSeoDUujrgUUaHvx3557ugcv66n48hl3QTBg6tbaJ4OUN2JScHFwlvfeAdQ6bMflvQhHYDMdq1U+0tVHn/HF5+ZmT8MNHxGecFvQJ33fUBMuAfoY1t9M8UsMXM2ox6o0Sze+V+uoXnUhpNLbTYl/Me4GNNTOUNTgtddYQAJle0o6u6P
 IL0ZLFt+
 rwtkyO812qZkgbB9M39qr3xEwN87BH/NVNoZO182ClYdei2o8X5EX2k1gCFQZ4f+kd6y7wAA+Kv/NHo/rZkTfOIdDYDRqq7I2toWBej9KAy1IvTED0IlIeE5IB85H62KoNJKvPEAwaJSc31IJvTbUSazy/bxZAGFCp2ivi39feW0/oFVAOO7RBR//qAtEyJ+cKqlhKdBYSpiBLjuOoTXCd1benWJBojLRtSWpmb2gF/Mw8jd7JC7JstqsV1+KDskCvdRX5hXHWzXLK9OsbC4Q/adx09QaL72F9msNNukIUs7QNa6MrgEzH8jI54GhGkWqxrvLH2m7QngUZz+xYKqSJz9ZZh2NOGX2Zu+WlGFB4imO81GzSwCvKJeCO0mOz1CWmIA8JFQWZdkfC0YFMdrfy4U3PS4IooW28MjrIQZs3VPwvjQmukDFw/F+Yo8VmfE0n3U21hsZCsr99P1U1j9NyP6k/sKOmK313zhRarrB78fUUO73dBDBkVvHsXqGuJDGyhtUxMtod2d0H01za/yEABWPbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 8:59 AM, Mike Rapoport wrote:
> On Wed, Nov 04, 2026 at 09:42:17PM +0100, Jose A. Perez de Azpillaga wrote:
>> On a KHO boot, a reserve_mem region that can't be revived is allocated
>> from KHO_NOPRSRV memory, which includes the bootmem the next kernel
>> boots out of. With CONFIG_KEXEC_HANDOVER_DEBUG, preserving the region
>> then fails:
>>
>>   WARNING: kernel/liveupdate/kexec_handover.c:1245 at kho_preserve_pages+0x168/0x180
>>   failed to prepare memblock FDT for KHO: -22
>>
>> Without it, the next kernel puts its memmap on top of the region and
>> the ramoops records in it are lost.
>>
>> There is no use case for adding regions across a live update, so fail
>> instead of allocating, and drop the TODO.
>>
>> Fixes: f99230780211 ("memblock: add KHO support for reserve_mem")
>> Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
>> ---
>> Changes in v2:
>> - fail on a KHO boot instead of allocating outside bootmem, as agreed
>>   with Pratyush [1]. this drops v1's patch 1.
>> - not an RFC anymore.
>> - based on v7.4-rc1.
>>
>> v1: https://lore.kernel.org/all/20261021211058.83483-3-azpijr@gmail.com/
>>
>> [1] https://lore.kernel.org/all/2vxzfqxglrg6.fsf@kernel.org/
>>
>>  mm/memblock.c | 11 ++++++++++-
>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index a450092a80fb..e325e0542c9a 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -2827,7 +2827,16 @@ static int __init reserve_mem(char *p)
>>  	if (reserve_mem_kho_revive(name, size, align))
>>  		return 1;
>>  
>> -	/* TODO: Allocation must be outside of KHO_NOPRSRV region */
>> +	/*
>> +	 * On a KHO boot memblock only allocates from KHO_NOPRSRV memory here,
>> +	 * which includes the bootmem the next kernel boots out of. Only regions
>> +	 * handed over by the previous kernel are supported.
>> +	 */
>> +	if (is_kho_boot()) {
> 
> This breaks memblock tests, please add a stub there.


oops, sorry. will add it in v3 :)

-- 
cheers,
jose a. p-a

