Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39A84C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 13:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 360616B008A; Mon, 31 Aug 2026 09:40:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 311476B0098; Mon, 31 Aug 2026 09:40:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200366B0099; Mon, 31 Aug 2026 09:40:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E211F6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:40:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 652A4120143
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:40:08 +0000 (UTC)
X-FDA: 85161673296.03.6187116
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 65C29C000C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:40:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lxQ3lSbN;
	spf=pass (imf22.hostedemail.com: domain of coiby.xu@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=coiby.xu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788183606;
	b=AlsdOepoO0DqxfcDcwCO0rK5iKk6QjtzKMEUN/BV3+qR7Ta2/fUrdUDsU9xvb1CeygVLLm
	fh+rz2JQutlJXI4MDIvGxplLCjzQwEpzreUEfV2zJpng7u7QLybXwZ68sQfSYPT4AzSfDr
	kEo2cVpa8uBuTWFvELNlS8HKxg90DQ8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lxQ3lSbN;
	spf=pass (imf22.hostedemail.com: domain of coiby.xu@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=coiby.xu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788183606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53920xzB8XLNSjeZIZbkJ3m9LVbpBiAgUUyw5Vt5WJg=;
	b=1DO8FyhMgA3Up8nHQLiwLDhsBsJK3EYuA9EGSzLupmU4HISY3FzzsdEG75HAsZ51M+5fEg
	QcLM5hOWh+3ah6xEMoQPuD+INa8XgMlCjHTrCA/6oV2VErSvaL94YQGE/7oOkPFFTbU2WJ
	YypJ49WivUigiP7b9zSVB9aNrXzB2TA=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cfbbdfa60bso38712075ad.3
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788183605; x=1788788405; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=53920xzB8XLNSjeZIZbkJ3m9LVbpBiAgUUyw5Vt5WJg=;
        b=lxQ3lSbNJa+C93UEsF9vILSTr5pHaDo5SEAXTc+73t7T3RBINIP3Kxgl7H0tbnRfdw
         XYIPj22qMzGji26Y/S9ksCWzGGJuqP5cAfbXnNXNHYGCzLfqG5rY80oDSQp7b2ouKhEV
         EtZNgPjytaN8vNt0G1e6N978+kfm2TYcvYCLYSs6ByLcaReM7fUu/Y7JzTpcrERL2c8j
         exQVsV10r6X+06pX8tAl805WFC9caXf8gExQCaMNFFHam8/+nkwQSJVV1nBJNUCaaG9K
         OmT+eJDS92i+vcLZmssiP6yO2ZvOiVLBf2FXPBz8Xgkqj7b/WOcSz97T6er4yw7OA9V4
         WWfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788183605; x=1788788405;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=53920xzB8XLNSjeZIZbkJ3m9LVbpBiAgUUyw5Vt5WJg=;
        b=DwjPX4k7rsvZwcJbsX/VzCqQ8ugcr4O08aRDzMLCBKCqGcNUwKPyvh/Fn1ecCj71+g
         iGhVH+tnBvsD0IdLGPEK0hGIPU9rRcGWpLJx4Ull+Gah/jw8N9eFIcMx40bOnxhlfVgY
         qzQV1NiXNKj1psL97FItJHO1cRFHdEkZB7KQ635gSVo/Ujw7N9kt6iaRCIXdZA51m4gV
         xv/Efk+iVKr+3RgAoEXWgFlYaRukyY1e4abxpG3jwoj45JUOHv7iOyHJroP5K+wGRWS9
         dC0BipZWqsGARgGJR5cTDitb636lIzZc+cyneDxoDQtvLSPH/hjPWpIl8kjQbp1CRDQ0
         DGMA==
X-Forwarded-Encrypted: i=1; AKwUvByeF5tbKNPh8xEpzR2/gETBGmLvu1ZJJqSNlWBKtxLhgjlXBi7G8l/+KxmNa+VzRTa0pmSX/DfL4A==@kvack.org
X-Gm-Message-State: AFuF++me7iXedRlQ1h6zY+A2DifsvgI80/JofiDzldkthN2wn0ohj6pc
	XzDdsSUCmNPBwmISrJZhALl3ITUAuNmBm6Q9E1kn5cPQlb5aNkBLyT4b
X-Gm-Gg: AYBFou13xOJGHFKghw0l72fLyXylYW5eX1gDayAweW0RzTfH1rtFYhotywRxqcXMNfB
	ojlAJW34e718k3T8wvGtloGCtQfEMDKjXodYGgR+w3LPxMN6y6btDlLmAINqNGzyjLkjd9EXsHZ
	zDS+rrA5YbbJ0J+uM0C1b0fPMiskzrny1cS9SugcSj6eCj3AVym8TePdbVYE41ed/bj6CKGH3No
	WWc4cqatrkoV72K1X8vU3YbQwk4l53xdGdezuZeDd4ixLaOFjNPGWRknvhA28+/3RsR8SIRewSF
	gbX5CosrInaAXjG+BDoI9jWq+JmP3h45TVb5tlEhHPGzg6r+ScdwKSLyyemR30F7kiALNo6w3GQ
	FT7jpDNUX4YbDYoejrZ+2he5KWXVRHuEzBgRZljOaJUsqrolOy+/yo+mKxtBZW8LBpKUQPpE4zn
	gP0RJY+ypnrewpIogPVHmHrNvBPlmcapeFyyD4sZKmsJAtqBKpE+vtbg==
X-Received: by 2002:a17:902:ce88:b0:2c9:c952:6e9 with SMTP id d9443c01a7336-2d74dca2281mr379634065ad.2.1788183605112;
        Mon, 31 Aug 2026 06:40:05 -0700 (PDT)
Received: from localhost ([45.112.44.97])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286fa20e2fsm30550306eec.28.2026.08.31.06.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 06:40:04 -0700 (PDT)
From: Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date: Mon, 31 Aug 2026 21:36:33 +0800
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>, catalin.marinas@arm.com, 
	will@kernel.org, mark.rutland@arm.com, chenhuacai@kernel.org, kernel@xen0n.name, 
	maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org, 
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, 
	hpa@zytor.com, akpm@linux-foundation.org, baoquan.he@linux.dev, rppt@kernel.org, 
	pasha.tatashin@soleen.com, pratyush@kernel.org, ruirui.yang@linux.dev, kees@kernel.org, 
	thuth@redhat.com, gshan@redhat.com, jic23@kernel.org, james.morse@arm.com, 
	ardb@kernel.org, leitao@debian.org, yeoreum.yun@arm.com, tangyouling@kylinos.cn, 
	hbathini@linux.ibm.com, adityag@linux.ibm.com, ionut.nechita@windriver.com, 
	liaoyuanhong@vivo.com, seanjc@google.com, fuqiang.wang@easystack.cn, makb@juniper.net, 
	piliu@redhat.com, ebiggers@kernel.org, jbouron@amazon.com, mclapinski@google.com, 
	me@linux.beauty, graf@amazon.com, bgwin@google.com, robh@kernel.org, 
	takahiro.akashi@linaro.org, palmer@rivosinc.com, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v3 07/17] crash_dump: Fix potential double-free of
 keys_header
Message-ID: <apWDDWhkVMIpKWS-@Rk>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
 <20260826092541.3905933-8-ruanjinjie@huawei.com>
 <87186b8a-f68c-400b-97cf-8ea6129eba69@linux.ibm.com>
 <fecbe6ee-12e3-4f3d-94ac-eb7cd08eeb0d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fecbe6ee-12e3-4f3d-94ac-eb7cd08eeb0d@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 65C29C000C
X-Stat-Signature: qo5y6uxyebxmjh7n4163rjmspfi6kccg
X-HE-Tag: 1788183606-164379
X-HE-Meta: U2FsdGVkX18N1OzyqXt5Uq6g04t5bnfvV1wu+lIefZkx1d2tU3mwHJJmPQr0dPm5KAsKhCWE0IZLALDOWOITOfS3C9ZTPHSI4Twn1fgOYjoGBsJmosi9OftIWyiE6+UKZaAEnJAxpnZAY56wX+kETG3t12cfVM82akfvZZXsJ0cunXAqp/LUIXTrkXVZZlS/wvtRvNMEbjOM89iC8BExzy1Y2FHVt5lTzyqF1j+dSfX3/+XFGxAFkcHZ6Wf0p17DzQu8mdH2nys1Bj5lFwObws45z4YKF3A3/yQxWfu/osg7g5ycE9bY0GQ/STHMUttKSrsM+cumL999cI3tzvtEPkNijQ6M8fOp+UK2UnVf7Tw/FCBvJvHF3TKe2t2FcO+XRXmW85NS6jcZUzyPqOH371gfwejUUo8j9DAKiZLJjx5HK3Zf/YPDAJ9nrq2I3+Uor28DDMfYW6jy8CSQIoyUEksHVKOCVlRM0IELomOOIcGPxQZ0S9J1HJ+Ca1YevyICQU4C2MHYWzTP+qatsWtXNG89gTPKAz2RpCrMaojmTLlGLUfycPTohPUV5QQWModemyQnCf6Hm8LMpeD2IgWieEfFt0wc96GpGP05mVzaDWmS0knOEOyXlEA+bx/xMv5BjrGed11zKC17nx5w9/xApPVVUnY8vf8LT5o/4C1Ke025Hf5EKThbVF6wBC6E7qodVsXTxG1V0odt35yCZNt0VE1D2PNSJYJFBiUcI3qC+YlT6a09o7mVewsYaCkIbNmesrxIvTkjo1ClcDfFN0RD8FP5lMeLE2wtRZOgzCOLTtsw8Qk42bvA9nq21FdajgKZ9YZ1GJE2j/J/YBxfJGDQsPrgFTs8ObmfXPnFuVTB03LxM3V4PNeKs1LWaS/wnyN2CSdpxd8l+ZeYASrS9buhwcXGnMoJENuO/Z+5dxmGNEBKTbuWLEqbULWqQF0mDjqR0WTHCndXsvVQBHdvuE+
 KOXzJEuc
 FVhd8e1QKIc+gssLEszV3HzdX7stZs58G+hcvA/SQTknS79Kf8sXvU+e+TLgVrVwS5rcFQmBENHqw8A074Wn+qOHvfXTk3dZkbixrNvdx9MHRjuQR1PSVLn0piQ1VHuufnshTPZse/EVqwewmUQaLzITaN7dkEXGNqI4YTF+gMR+q8cH77sEP9Ziov9kSvuzb0I7fr6BjZjm7mjEE9/RoFuDjV991RFo7S+HIYDMUjBZRqutnrP0eUpqYw3FyD0To9WfuFpfzCHUiK3iK9JBhT8gV0yscrznocVAAPlMtMb2vlRpc4vbelgHVsf34hj22BSsFk8dfp5cvYwZ+suRcO7LCfh7xMvQk4YN2kU1D9hm1UGYtvmuH4jjsBMVjgrlYzJur4rw3a6pBxCZk5dJ0tx4O1LPEj/s8UjupOEUbuRZCHJmRZ4NCxedYpQR5MMrLfUC+VPgpLmBFtawV0GgKu1cT2BpesYyafGH95iTRE8qPSP5yp+c+vRHgBhspV8n7UsEjo542Ru3M87/8sx7amUvw57hZayX9ODo3gOsetZm5ltLXsAsT6aKIC1Veog8uF/f1xvDSiHD08SQ1Pt3KHRw1bWoYYCW8e2p3I/ccPqVcwUJIB77UWUID2bemmj2wrdVDaqpnEaD0jZp2Bs5latDNawPzxRw4NNO+S2G13RBdwv+POcICjx6dF5Qr+Ai9HmjedwgXfi6NzT1hx2DTFR4QK5GweIRBCYntYFIvQiv5sZo996FiDXT4CLpIkiach9rnzlA/P0RZ/S4nTp2+B12iGHJeVNDnymINLzKKKXAFMR7ep9zmjVBq7I3DhnBiNxNKbErClHpj3Boe9UFIcdAdbifXCzLbYrnh489tromZ/9F/tmrr22shr8w/STnJxFtBD+D7G/w0Sct2TZQ1kGk0ZK0Fs0t1UgZs6/ZWDXWczCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 09:24:07AM +0800, Jinjie Ruan wrote:
>
>
>在 2026/8/30 13:59, Sourabh Jain 写道:
>> Hello Jinjie,
>>
>> Coiby is handling this issue in the below patch series:
>> https://lore.kernel.org/all/20260828084900.1496839-2-coiby.xu@gmail.com/
>>
>> Since the above patch series is all about crash_load_dm_crypt_keys,
>> could you
>> please consider dropping this patch from your series and reviewing his
>> patch
>> instead?
>
>Absolutely, happy to do so — I'll drop this patch and review Coiby's
>series instead.

Hi Jinjie,

Thank you for agreeing to drop your patch and review mine instead!

>
>>
>> Thanks,
>> Sourabh Jain
>>
>> On 26/08/26 14:55, Jinjie Ruan wrote:
>>> `keys_header` was freed in `build_keys_header()` without being reset
>>> to NULL, and the error path in `crash_load_dm_crypt_keys()` freed it
>>> unconditionally even when reused, leading to double-free or
>>> use-after-free.
>>>
>>> Add `free_keys_header()` to centralize freeing and NULL-setting.
>>> Use it in `build_keys_header()` and only free in the error path when
>>> the header was newly built (`!is_dm_key_reused`).
>>>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: Baoquan He <bhe@redhat.com>
>>> Cc: Mike Rapoport <rppt@kernel.org>
>>> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
>>> Cc: Pratyush Yadav <pratyush@kernel.org>
>>> Cc: Dave Young <ruirui.yang@linux.dev>
>>> Cc: stable@vger.kernel.org
>>> Fixes: e3a84be1ec2f ("arm64,ppc64le/kdump: pass dm-crypt keys to kdump
>>> kernel")
>>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>>> ---
>>>   kernel/crash_dump_dm_crypt.c | 15 +++++++++++----
>>>   1 file changed, 11 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/kernel/crash_dump_dm_crypt.c b/kernel/crash_dump_dm_crypt.c
>>> index c685497cd470..ed0960ff0987 100644
>>> --- a/kernel/crash_dump_dm_crypt.c
>>> +++ b/kernel/crash_dump_dm_crypt.c
>>> @@ -363,15 +363,21 @@ static struct configfs_subsystem
>>> config_keys_subsys = {
>>>       },
>>>   };
>>>   +static void free_keys_header(void)
>>> +{
>>> +    if (keys_header) {
>>> +        kvfree(keys_header);
>>> +        keys_header = NULL;
>>> +    }
>>> +}
>>> +
>>>   static int build_keys_header(void)
>>>   {
>>>       struct config_item *item = NULL;
>>>       struct config_key *key;
>>>       int i, r;
>>>   -    if (keys_header != NULL)
>>> -        kvfree(keys_header);
>>> -
>>> +    free_keys_header();
>>>       keys_header = kzalloc(get_keys_header_size(key_count), GFP_KERNEL);
>>>       if (!keys_header)
>>>           return -ENOMEM;
>>> @@ -441,7 +447,8 @@ int crash_load_dm_crypt_keys(struct kimage *image)
>>>       r = kexec_add_buffer(&kbuf);
>>>       if (r) {
>>>           pr_err("Failed to call kexec_add_buffer, ret=%d\n", r);
>>> -        kvfree((void *)kbuf.buffer);
>>> +        if (!is_dm_key_reused)
>>> +            free_keys_header();
>>>           return r;
>>>       }
>>>       image->dm_crypt_keys_addr = kbuf.mem;
>>
>

-- 
Best regards,
Coiby

