Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A18C606A331
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 20:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PYRhp4AT
Received: by kanga.kvack.org (Postfix)
	id E3DDE6B02A5; Thu, 22 Oct 2026 16:16:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEDEA6B02A6; Thu, 22 Oct 2026 16:16:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDEA46B02AD; Thu, 22 Oct 2026 16:16:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A14346B02A5
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:16:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CFFD514022C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:16:06 +0000 (UTC)
X-FDA: 85351368732.10.344258A
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id D3B8812000D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:16:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PYRhp4AT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792700164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=04uyNLgdlYA5nyi3rp36m8rV5w4iXYQ3w9Fx975SKe8=;
	b=C069XqdlvjoCcDEveUzkpFzgd4nZPgFmBAxMtha+JU3VO0Q5MIaIhCh8diRXd4/lKK5wrx
	NwwgsPu2wVyuii7NUwo/MvodZBMavDl7nw1v3ZzBB6DGhQnLggTwYi01w96+Y4DZslv/Za
	CAxaTpBFddIWMGL7N0xJwx5Pl+7Osi0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PYRhp4AT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792700164;
	b=OSQLfFGWuKYw9Go7l8bctm8ISYLoN6WMSoQ+9YxJO9c//1emcpb5Qi9+lwi8FfaHAjCBAJ
	j+5m6xIgIs+KRuMPQufLZcvW6tvElXtjUvs/D3DtTBRPcHvtj0xadTy3dmd51vIZUTS58D
	3HRt0YGFDAIKjLzAR5BB5sVYhxU6zVM=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a1ec92f655so1379795e9.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792700163; x=1793304963; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=04uyNLgdlYA5nyi3rp36m8rV5w4iXYQ3w9Fx975SKe8=;
        b=PYRhp4ATXL3NXCXu3r+9PIDaBGLnq7S7Cc8PgxJW35LLrXwoqUP7OIgvBbs+BSfciE
         ZtFywt/wQRwUDktc4iyearVc56LHl/X+4AuUkKEJKuNq7QwI8FhyF9PaVtjNHQhWeRdc
         qLWEw49DedMH9yI0/bjjJhQxinMmqjUyWfhy6syJL7Dzs3lhLl5Z1jbM420oXbOo7iUl
         EwfbHH/3W3rc876G+WqtNwXZbroEpuqdMEOUVeSHWtv9fXa/cu5NdKnaaFLjt+npLOIJ
         w2y0W6VsALSEEYudV/nPIYmwERHZnyVqbmnwJpg6cJQGx+RILdOor004uucvKJRkd+jw
         lTHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792700163; x=1793304963;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=04uyNLgdlYA5nyi3rp36m8rV5w4iXYQ3w9Fx975SKe8=;
        b=Tp4I6XtOqNNIGH3D/lBEh6zYt36WInF+aSSQKObRea+7r7yuVrJeq6jSp5Jt6HEoKn
         ncDYBRR2TWsyFhwoFKLlDaHcorEhGgzl60JlJseM7fFvrNdtuJNOzZeDTMguyzE/cplE
         FUY+s2Hgb2lAKb4igwIFkF/s+1Zu+4Wa+5iRpaPCYNKHwwPuSf7KwDBFtZ2Iodei8Hji
         7Q5jL938SDxAPJHkunTcFFup+YcutiM6DLQVXBSgFxgGmlw4kfO/ne6yFEzDOwOLC//S
         WZM06ns3IO8OLSdq4wHoV1nBGzjribV3if7u+kXUMkWlCNMXxreie0KVJv9XsHQCMv4c
         bmaA==
X-Forwarded-Encrypted: i=1; AKwUvBxj+CwP9KFkgLvDTkSgJLDaHFm/obe+Bi5u/+i5tABc8m6hW7YyvVt2E8hpo/zRr0i3FcHP5I0KOg==@kvack.org
X-Gm-Message-State: AFq9FYJNDsWHbsEOaRxf7bg8460Lt2Ja0fePdCrBjOPbWppGSTTFsTyt
	6Qab1ZvumIfhlXqER6FR/qeeKXMeNUSVi9+ycfmQquf/KB4PDb3rlbHh
X-Gm-Gg: AYBFou2WdxX5AnuJfjShE29urw7dq8OnEplBNIwGZy1S0+lwdcWsAhcfViu4HByt7NU
	iQO/PykEBfIs2jbWHtoeGW6rs6qTepjvT34A7a6bjTR4mnbtPGp0jMUfIuXTxv9M50s1CkCZGzZ
	YhQaqcFS55zd0ZyoPmGKIq6Sf3Jn4kiNEuc7d3MALax6HlWI1QNF5HndY1TP/k7X3fM0W0NR3PB
	npkHB/kuEOnE3jXRZewmU9P5o2k4nEVy+cdvus5VovgbzedpCJEA3hcylNDQQw3IbeVN4k2SsXs
	MkCDfOj2Q18/jjiFjPrs5vTR3KDjdDSvJX/DMTDYX5bQUiLZgkY81f2wewy5+5rjvcc3GPc7p9w
	dbjJgNguUfG7UlxpfUG+8BI9aqMWZw5ScxeTFL0/AiOexp8BwO7F/z1KcWCsh5UF4A+XXZdPXxZ
	z33JBIlxDoM4GpK3hrkZyWOz2XGTs8122G7lAR87bKO4cf0wjEX03MVkaQkAhIjui0VcenmUjlZ
	7qUDdkqrAVqVFiw5DH+nVg0zq+KJO/VG3XEzT25Uz/HNKiCnOddEGl322ohphpnw3Wjk0v7
X-Received: by 2002:a05:600c:a010:b0:4a2:317:d0ed with SMTP id 5b1f17b1804b1-4a211bef3d4mr3013315e9.1.1792700163341;
        Thu, 22 Oct 2026 13:16:03 -0700 (PDT)
Received: from [192.168.1.18] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a2123a1797sm320905e9.1.2026.10.22.13.16.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 13:16:02 -0700 (PDT)
Message-ID: <32dd1f28-db55-4674-99bc-74d9d3ab25db@gmail.com>
Date: Thu, 22 Oct 2026 22:16:01 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] memblock: keep reserve_mem regions out of KHO
 bootmem
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>,
 Alexander Graf <graf@amazon.com>, Changyuan Lyu <changyuanl@google.com>,
 Tony Luck <tony.luck@intel.com>, "Guilherme G. Piccoli"
 <gpiccoli@igalia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Pasha Tatashin <pasha.tatashin@soleen.com>, kexec@lists.infradead.org
References: <20261021211058.83483-1-azpijr@gmail.com>
 <2vxzqzhhg8l3.fsf@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <2vxzqzhhg8l3.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D3B8812000D
X-Stat-Signature: 5apc6wfyspiz1jiwew5yk3qj8514s6wn
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792700164-844727
X-HE-Meta: U2FsdGVkX1/QsqdxHzDtUpqD65MWmD9ixmUrdwxxpAErUB8f//D83Q2kPnXDXKoZzjSKUv0c+IFVVVhKQZD3cQ5oSX3iujLAZDKtVrzxb0/QF0/IeYf7HLG3UfaJA3FON6ZEw1+6MvMsBqoTvuaii887StLXgJKyYEKiL2Zxea7wbAritWMfHiC8ml1I4+FB8IOmOGdVOtT+SWqahSBOYWhS5IGAFs6rtuGnZYbi+pY1+1gFXt9fpq7vTgAAT/xiXgGbVYD2GNpOOadLWjwbDuPfsZdzY8Bs6g3lXRdVV9bw8vCOeFAnIbJT7zD29gM0iJ1kJ8Iu0a4j/SBSqcsonfbXTREdRPCZIDzVxKVk3vIDCZ8P5lqhwfz2wBQHqRSxQvPWWL8aY6yV3kQjGa+N63vG2HxrDcIPF6rvBa+2NXqy/eMcHFsUJOvDtDEJSBwnVTqaj8wqawkz+th7z9jzHOnqx4UnLGaysK39nohTKYWfdqBJXXve15SGetRrAX+r6pQfSXEq1aJcSRHazwqA7nASla45iXEiYY8QAasbtIOJ27QbSJosgNiZNGIwO1WHA7bse8oBDf8Mda3v98vPS130/rULIbG+y0IXI4zsnTS/IV/fEo46PZszpHvG2/qW1oQ5kAqtk8CgW8UaM04urOIz/zvOxm7swog6Yy6sVmOwprR7KYHou3gZg6gkoIO7k7nO3QxPxt/X6CVgNJs2bjeonf9FSyPIP1EwZbVVekQUf6UTedIQ4/ak88wwEx42iREHxz+GUFWRV7c9oIYh7x46Vqh9kUCcLg0NypA32PHeTqr9ACH1RMyll1NSAnY/c6lzVzxCn4JDJ88zYXK1LxHgeFMe7xHJEf0sO4AZtkYjBLYrjTz70crtGKuT8eo642lUl8ne/poN78T/5Wqw9nBgR31k+IiBmHjcWKgVh6tAmEb2rh2dhei8oa325lDyilmTJ8gdyb/A+Qx4YeN
 jvzotHrS
 0g+o2WbvZPjBxxHxSoqMZfQoeHJ3fHeyRIqj20Ju71dFLbWcfJS8FGIxHzeSYXVR8A/XHT5vt0h/grGgByXuvpuW49b2UA+gH9rPoePa/FxvH5Or1/66+/KEFjF7lMkG4+yq+GXOajb8HwC94oAQ1UxkV1a9uVM5a+H0LKVuWqo3y76zy39ZC5YHSyU8eopv1kjy79fL8fO6RrfoSq44BXxcyXgvfAdIHLNFh67R8Fio98ScdUeFBvVriamRqCojVo9Q2cQmVhlPeVZl4szOli8T/h7qDjdPQmfTMIUG5HFiQyp827S2+tIub4azk2WQBxWKPB/lm8j9J4k6qMpZcKeSwbEHg2Fy09RsNMj8hV6Cmfjsmx6I50Z+zX34UDohj/AnIW2o+gulQC4koMGZ2T8kYSb0Y4jo8iZd6xY0B4z039AXJyUtVb7DE/zI/Y0iiWcrlYWoJwPZKf8mk/STL9QxPEZvdBkpBSzDkvEHX1QS7oyFfEMWAzFuVP/xbSEye2pIH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/22/26 3:37 PM, Pratyush Yadav wrote:
> On Wed, Oct 21 2026, Jose A. Perez de Azpillaga wrote:
> 
>> On a KHO boot, a reserve_mem= region that can't be revived (new name,
>> size or alignment) can be allocated from KHO bootmem, which the next
>> kernel boots out of. With CONFIG_KEXEC_HANDOVER_DEBUG preserving it
>> fails; without it, the next kernel's memmap ends up on top of it.
> What's your use-case? Why are you adding new reserve_mem regions after
> cold boot? I'd rather avoid making purely theoretical fixes.

I don't have one, I found it through the TODO. a different reserve_mem=
in the cmdline passed to kexec is enough to hit it.

if it isn't meant to work across a live update, would you rather have
reserve_mem() fail on KHO boot when it can't revive the region?

-- 
cheers,
jose a. p-a

