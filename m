Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 323CC606A338
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hiDuFh5W
Received: by kanga.kvack.org (Postfix)
	id 39BE06B05B1; Tue, 17 Nov 2026 03:58:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34CC56B05B2; Tue, 17 Nov 2026 03:58:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23BD26B05B3; Tue, 17 Nov 2026 03:58:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF7B26B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:58:46 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B54FA7C26
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:58:46 +0000 (UTC)
X-FDA: 85444010652.15.47131B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id BD2D4A0003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:58:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hiDuFh5W;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794905924;
	b=i5jii1wBB6Tzk8zrEN5orKq/z8g+aTEK2PJ24OryZkxQgx6f6NPaptLdppT7gPHKtv10FH
	9kJRj3sSYhKQIbMYZ8HmeMoZKR50lVNWBTU8bqlcKYRExTpcB274KkqUTOwK4FqIEHzMe3
	XKU0irtniHARX8Jpn819mkp/VRaPJ1o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hiDuFh5W;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794905924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sdaJ46qgDtJZkPgfo2bi66ZtW6lZcvzV7LDkXsyhjRw=;
	b=DmRaS4PO134+cMX2KoLrDYglVthyi88ZWBOKonK0R7b59Rmrjh+/HHrFCfA+cUk8bonWSG
	djLp4/UTlhcT3twj4dk/YWD1+AfA3MVO5RxEAvJQk8tj7SlS9vY8MK84lTzij2Rvy+h7dk
	hD+7VfL9vl3fC4/bYhDDOTPD3hrVamU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDB94612BA;
	Tue, 17 Nov 2026 08:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCB71F000C4;
	Tue, 17 Nov 2026 08:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794905923;
	bh=sdaJ46qgDtJZkPgfo2bi66ZtW6lZcvzV7LDkXsyhjRw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hiDuFh5WlgG+JKxfQnO28g51JpHD1Mpwt5nYbjHiiOR8aRqwmndsTM+bhPwQirfyM
	 s7IZng56tkBWK1cNTMafNnMeR7kd8g/EIP6m45rcIGg8RsKHKQ+qutb1ANFwdSpJTw
	 QPsq4b2VgYBhcjvMjzxrj8EIFzBoHaqQu5LTuQyIENby1vTb/Pu90TRJyifvs3tkIT
	 i1zp/qRsJWEGoASA0CQiCP7xo7/29BdaAXi2/9l6qNrFRmsVxZX4Z7/S/VkiMO3hmF
	 rCeEsTOo++1erxKHvI5BP5IJmyjS8U4aTmKifv4ungSKCdKOpEEF6ibgBK/7DPsCQ/
	 WjCBZSjVEU9Mw==
Message-ID: <486cd251-f7eb-4162-a1c7-92f04f480a6f@kernel.org>
Date: Tue, 17 Nov 2026 09:58:38 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: handle implicit read permissions in
 madv_populate
To: Xionggui Chen <evers_chen@163.com>, akpm@linux-foundation.org
Cc: shuah@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Xionggui Chen <chenxionggui@lanxincomputing.com>
References: <20261112031811.56500-1-evers_chen@163.com>
 <20261117070606.3752-1-evers_chen@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261117070606.3752-1-evers_chen@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BD2D4A0003
X-Stat-Signature: m559ammoym4yjc3rb7fmrsimx1rgdr7d
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794905924-138248
X-HE-Meta: U2FsdGVkX1/ri5panM1HCKoOKXSFMegafZBSvvjMzFBJdYaIUe7hcn1Mk2nxbeIlcn0eF5MJZVwZ23Mrc8IUlMMKpCKen1QmTSZOoMlCjDSgwiyKtYjoe6/Ng2vLIF3HQhNor5Qj1rNwAp3c0px9Vcbw6kAm11sASU8DMg4thAgtysmAw5Sl+meNAWN6YXIHYoE+Jl2n3wKLZ1zYLYwiJ8nmjb2lsFD870z86hYd+nGquD0k5JnP6qKnaS0NdabfBznv/u8AGJZW5u8U7uK0VKnd3Qh6L0tw7YkUK+uALOSNzcR830GMGWCItbQC6/Wg7JNxPwjbETNkF5oa7siu3DuwdKsHqZmQYHcU4QAexqEsiff0xXzQEgROfPYkdrQ6cQBJkC/Wu1K/ZFTr7k8w/FRddsjcqHZR2hz6n+uhrM1Oq4+iswehu7tawUgE/fMSCQa1D/6c8uUGWl6N1F011M+VCM2QsO2qoagnTVstcO8AIO27ItIJdQHygKL+3duKEa961P9FLJRJwvcaCm7snpiAuF2aTXSm5HZs004i2SRodqbAmq6cfKW92zk20StjI+BuOevXSv1QWEVEIajcWeOCtn7qTGX0APFP++jv/tj5g71azrKgqLEoYkiQAzDJdWUh9jBydOzfTdf6I4hKhguHuHiu0EhXq4gPZtmV2xvUdy3b3qPmvtnj78C0saENv68c0lZsyRtvt2M8tii2atunNs/ONi29MD3c79Kt1yiOSTz0KAsg94z2tjYXbQQxTCetMdNcRyIB4ykNEJbsdEmRsR4No5m/kPmv7qDUDkVhXwQJQaa9Ga8mHosgxM3U0L1AHWtIiCeE4u3Csv2hk8tWyPva7jAWFYloawHTPFh47s8XIJcBBV0RNiuatsuByuKl+OM0yL7pWJBNIg5SI+cz4uC407EG1C5HA3YyioFNHxPihh0E4M4X6YqqwqMmn60vz5S9vMAFjJHJqSJ
 JPLvzBjj
 AdqVVjh+OAg+kfJa0zt9tsDhb7dOOsctBpcxS0Y7XjMXk3iO4Tvj9u0Pvka3lpurcD9lg1RwaT4Gbu+kXzvSM3/2ssUdbur+cJSz7vjK3dRjFoLdfDu+xLzwMiGM+hWuDzaZ+X5BYIS3erEXjoDSlsyrGW94GiwqZVXRzqtU5H+QsZPQFPXb4XIjqU8GT9s0RE6KUpbBstSxoUkAfON0YI/o5A3sNZCoDodYJEx++wRl4NV7tVNzuVqICVrngqbqAzzoaIidVpd123t8DyUGWOiSN7gSnUB1XXPcx8dV97Pz69fOzXjffd7h9P/pNEAsi+mcRNUQVBSLfc4pNKZMl2HO3zj416e5k/FCdKKQu7y5qVxfg97gVN/1IGgRZh62swGPCW2wQNXA89YpEjVWx3GX7LaeweHj1K1aP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 08:06, Xionggui Chen wrote:
> From: Xionggui Chen <chenxionggui@lanxincomputing.com>
> 
> The madv_populate selftest assumes that mmap(PROT_WRITE) creates a VMA
> without VM_READ and expects MADV_POPULATE_READ to fail with EINVAL.
> 
> On RISC-V, commit 6c7559f22b6f ("riscv/mm: ensure PROT_WRITE leads to
> VM_READ | VM_WRITE") makes the kernel set VM_READ for mappings requested
> with PROT_WRITE. MADV_POPULATE_READ checks this VMA permission, so it
> succeeds and the test fails incorrectly.
> 
> Adjust the expected result for RISC-V using an architecture-specific
> conditional, while preserving the existing behavior on other
> architectures.
> 
> On RISC-V with Linux 7.2.0, the original test fails 1 out of 16 tests,
> while the updated test passes all 16 tests.

Thanks, please don't send new revisions in reply to previous revisions next time.

> 
> Link: https://lore.kernel.org/20261112031811.56500-1-evers_chen@163.com
> Fixes: e5bfac53e310 ("selftests/vm: add test for MADV_POPULATE_(READ|WRITE)")
> Signed-off-by: Xionggui Chen <chenxionggui@lanxincomputing.com>
> ---
> Changes in v2:
> - Use an architecture-specific conditional for RISC-V.
> - Remove /proc/self/maps parsing.
> - Remove the additional PROT_NONE test.
> 
>  tools/testing/selftests/mm/madv_populate.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/madv_populate.c b/tools/testing/selftests/mm/madv_populate.c
> index 7fce5d0b622b..fa26ca2d8cf6 100644
> --- a/tools/testing/selftests/mm/madv_populate.c
> +++ b/tools/testing/selftests/mm/madv_populate.c
> @@ -81,8 +81,13 @@ static void test_prot_write(void)
>  		ksft_exit_fail_msg("mmap failed\n");
>  
>  	ret = madvise(addr, SIZE, MADV_POPULATE_READ);
> +#ifdef __riscv
> +	ksft_test_result(ret == 0,
> +			 "MADV_POPULATE_READ with PROT_WRITE\n");
> +#else
>  	ksft_test_result(ret == -1 && errno == EINVAL,
>  			 "MADV_POPULATE_READ with PROT_WRITE\n");
> +#endif
>  
>  	ret = madvise(addr, SIZE, MADV_POPULATE_WRITE);
>  	ksft_test_result(!ret, "MADV_POPULATE_WRITE with PROT_WRITE\n");
> 

No that's a simple fix :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

