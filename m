Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EBE9CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 13:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C2298E0009; Tue, 21 Oct 2025 09:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 399D38E0002; Tue, 21 Oct 2025 09:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D65F8E0009; Tue, 21 Oct 2025 09:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 203D88E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:56:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA3621604EE
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:56:32 +0000 (UTC)
X-FDA: 84022271424.18.7378A13
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id D5A561C000A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:56:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RKuGP32j;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761054991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W/ZIuMu80DL4YHvTXi4wKlBoPxDfHVooxaFJqOtUjU8=;
	b=ft53i3PBbJ3ciTQox5ZEivo7O1JHl9y/XvDtgBDdGcwaspaGQAH8K+d038cCodNj50nmjc
	wBzISfelKbAPpg/gTH+BApWCJ49e8d/EdkGc6nOeIUwpzWxn4SpIO6xu8ityh+NDQQEy6u
	qb7MScN6N61wmndITTjXGCVybHFOgsk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761054991; a=rsa-sha256;
	cv=none;
	b=CUIZ1+vKMzsUgbUeZX0WgeMXnmK55kD64Mb1wEQOQxLtonMfF7k+ZFVbdmffydrs0mURKB
	48nrPS3K6uPRcdj43tBygV12YSZ/0ThXW2YCyCXFbt52ZaIo9vq9b2hDQPxIMr6rtq8XVu
	Mqpg6ICpB0OPam80VwgP5qDG0fytu6w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RKuGP32j;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
Message-ID: <d988780e-bca0-4ad8-9ebe-97e6248072e5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761054988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W/ZIuMu80DL4YHvTXi4wKlBoPxDfHVooxaFJqOtUjU8=;
	b=RKuGP32j4IHlZtowsmFIltam/JgXymORLiTTqtVjn3YyPXiwP3ZqmO5Cj1B0MSySm7em7X
	eUVdNzQVrCO6Ztv1MhZhqdpzMQOZAc9aYK6fjNEVlMJhmqZ5qmA15WBkDJo/GNcAVu2vxX
	bvWhUSXDtd6tm3O0h3ZtT8Vt+RVSe9M=
Date: Tue, 21 Oct 2025 06:56:19 -0700
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] kexec: Use %pe format specifier for error pointer
 printing
To: Simon Horman <horms@kernel.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com,
 rppt@kernel.org, changyuanl@google.com, akpm@linux-foundation.org,
 bhe@redhat.com
References: <20251016200320.4179702-1-yanjun.zhu@linux.dev>
 <aPdVSyLRKeRN3i6z@horms.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <aPdVSyLRKeRN3i6z@horms.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: D5A561C000A
X-Rspamd-Server: rspam02
X-Stat-Signature: 43uods4ey6jdettijd7diwba1gpd6wjy
X-HE-Tag: 1761054990-705848
X-HE-Meta: U2FsdGVkX19R81r6z+PmHWYEqat1W1Ugx8QZGLQirHoI0XK7RLBZ+IWjfDFsnMeE9sK1VhwyMhnO0CB6bIZMlYxTqImMco03CXobtzxVSGH/PAgUF4+u2T/wX5TgcrkHO60GF8h0KvdNKaO09scj7e6Y7rciE0fc0R0rjnyBJEuYKVHqKuXyutBFELPT8LMTe3we6WTTVZljAU/UUgKMTUvZwVHVHrh90w753SgFypbWQth71bg0dcLObdJqvN3zL4A8eJJmEMsot1jK7Ab+BOOxT11LsGvphj6YQNuOBrt+bdrbiM3M8RzVVCYPudMJc1Xcc2t43IIioTC2m7mGU48BtR7Z99EUxDDQoeTwSYmkNb/Vt431ZeYp0+oTQJbubMbCSyKy3s+i+zDaFMkpNYNT34HvTMl4pFFfHbXZ800QEHB1tTYK0jPj66f4K3S20cdqzacyrQt4sc/Ly3cvELkT6Zx+KzeZWF+FLumt4+O+tCoEHfG05wWeJhwg0d8wPQBEV87kD3LbuYQ3/mssbhkpRpgL/38s/U1khem7/fmKhGKzX55AUL7CJOgEkCGlw5rNfO62Jejt1bwK3QlttXyYaH2h3x5DMoPMUZvHIlkiGN1YJA3rIsSJZRN/xq7nzDkGfOcdE0KpolhW0kd+ZV8ForRNOUj2OPJxIVPJHKspQUaWKtJcHCCyg+sHYYwHMipAUUAiGsKw+a/D1NNek7INb8wXLxhQTc+r8lRBf/zFnefDfRgNCJd9r72uOy1B8cW130W0fQ4A8I3s2I212//jugT/gGymh4/uxeL+Ar6QcGy/GNr8GezmUJOkx69YUY53hgeDsGYcgzaJfj6fP+QL/+GgzSwiCStNat3c5Hl/uvi+FEhI6XsngxEYd7fT7IFVqEPSNQm9ftMjs9bOkUbwtee2R6mCeuc6tgCQs6eqYqpFSfwel9VrRkDjWIZaU84NW7NSghyFALdB4WW
 l8EIcpq0
 TMC/u9Topgy1nANFi7piKBLvZDSzwcDcmjnlyslQfOtoPHprCyxn3x1/o+Dz+stXi6Pc6nwuY7hydG5FY3YZCnQW0lAwCfgBR2pjiU1uavUyzbdp5ESQzbCp6HAJM99JIsfcOlOjswjJTbnOjv4pSr3fb3qasP0fEzc+ib1n/0JczDwMTdA76k0zUU77kYk9w3cFwDApHfDgi3tgXBu1i7o9sj3z0e7XMago9nx4r7RgZrfIOH857Xhmk8uy/gMM+0/9u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/10/21 2:41, Simon Horman 写道:
> On Thu, Oct 16, 2025 at 08:03:20PM +0000, Zhu Yanjun wrote:
>> Make pr_xxx() call to use the %pe format specifier instead of %d.
>> The %pe specifier prints a symbolic error string (e.g., -ENOMEM,
>> -EINVAL) when given an error pointer created with ERR_PTR(err).
>>
>> This change enhances the clarity and diagnostic value of the error
>> message by showing a descriptive error name rather than a numeric
>> error code.
>>
>> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> Thanks,
>
> This looks good to me, even though I note that this file
> has moved in linux-next.

Thanks a lot.

Yanjun.Zhu

>
> Reviewed-by: Simon Horman <horms@kernel.org>

-- 
Best Regards,
Yanjun.Zhu


