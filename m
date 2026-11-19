Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F12A606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 10:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MIHzLV8A
Received: by kanga.kvack.org (Postfix)
	id 937036B060A; Thu, 19 Nov 2026 05:58:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90F376B060B; Thu, 19 Nov 2026 05:58:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84DAD6B060C; Thu, 19 Nov 2026 05:58:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61B396B060A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:58:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F250FA8764
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:58:19 +0000 (UTC)
X-FDA: 85451569518.30.8C153FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 576654000A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:58:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MIHzLV8A;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795085898;
	b=r/NKrZTp31zlV4nADfTIAf5avyRsXe/P4fgRUlIwDhjpjmt5wulh8MqZis9cTgSdGk6OlP
	Hog7nNMKoutLdLPJlpJStP3wVgxfVektH4wtqme2KGLnmpwWfYDF4XtpwE+w2eEVU5ED/p
	SO0FDeiD8rgtF3aM06VrQvQZixrIsgU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795085898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+o0bQUd8q0A+WRUXZxAmN8P7csYU6Eu6m9jj0vuUv3w=;
	b=gFgWRnYRQ1CN1OOxJ3JV8iPdZOlS+NefZ/GPA41s7T/iA3HZwpCKV2QBrzn1HaNrn9FzUR
	dSKRFnNYdZgzEuFlBd/OfrYbr0vD1xMYNjSIIY8jpX9CiYEMYpqW7ywHfQA3MKya9M9t/n
	5FfVEWuEqkObp8lem/nc7l1u0W7EsbA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MIHzLV8A;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 050A1612E9;
	Thu, 19 Nov 2026 10:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA28D1F000C4;
	Thu, 19 Nov 2026 10:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795085896;
	bh=+o0bQUd8q0A+WRUXZxAmN8P7csYU6Eu6m9jj0vuUv3w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=MIHzLV8As6nXxtqY6me3mqzdXMBaRaBOWQfGJwhvK3jossC2GDG2Ra6MFKWW4G+PA
	 FSE2j3Y2nrgYKsoZRqeaQlmmR8HldEkKQX/ibJlGfPtyxwuDyYtL+xn/5wmzzz9v7l
	 5FGWgzmXPkWsCVt8Us7AHZKoM27j4CijTLiDv3A5kZZVUgHGXiPdfaNJLoY6UIIyb3
	 5zUQWEG9CGNQ5rsRZ+yKBwxyMv1MVd/HvFPW6rmUc8+i1/G3rENaOYczrKWZpdGWCp
	 PdEYWVcB7FsPeI2kwfT60Qzmw+M8L3OMHvVFc0+jgQvHEL/6alUpmO0kf3kFqCnvDg
	 nyLPMZIojBYvw==
From: Pratyush Yadav <pratyush@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: chenhuacai@kernel.org,  ardb@kernel.org,  pratyush@kernel.org,
  rppt@kernel.org,  pasha.tatashin@soleen.com,  shuah@kernel.org,
  ilias.apalodimas@linaro.org,  akpm@linux-foundation.org,
  baoquan.he@linux.dev,  ruirui.yang@linux.dev,  guodongtai@kylinos.cn,
  kernel@xen0n.name,  graf@amazon.com,  liukexin@kylinos.cn,
  loongarch@lists.linux.dev,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kselftest@vger.kernel.org,  linux-efi@vger.kernel.org
Subject: Re: [PATCH v6 1/8] efi: Pass KHO state to the next kernel in a
 configuration table
In-Reply-To: <20261119082252.9120-1-dongtai.guo@linux.dev> (George Guo's
	message of "Thu, 19 Nov 2026 17:22:52 +0900")
References: <CAAhV-H5Vse=pKC3Beqhqxa7fqadiGVNqkSy_06HZ3Luw2Pmj5Q@mail.gmail.com>
	<20261119082252.9120-1-dongtai.guo@linux.dev>
Date: Thu, 19 Nov 2026 10:58:11 +0000
Message-ID: <2vxzecch3x6k.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User:
X-Stat-Signature: c6k95ofio7e6f53xib5s4cj4yjot1wem
X-Rspamd-Queue-Id: 576654000A
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795085898-542356
X-HE-Meta: U2FsdGVkX19Uhdt7yAFoqF3Denr23UK3fVvrhX19BMq+jLE69JawIWLpWu3wyp4PLqBpUZcSAWCpGPVAsAYWZcXhHkpXBmMyN4DNFZtKRa0HRaLfXJfvkEpLGesGkjtl759/rDOM9R2Dbn3lv459mIJE0cb2h084aTtnDF3921gHgABaw/RNmNWoIIMRxuoi+E/98Pe7FX9F5yO81lZdj/NLcnIPAvNo3yJRVi57Don41losJ3vBIggDuA6BQ9jAa6hRi/WVk3z7GboTFpfoy7QikZ6a3HNDOfNPQCm05SXlNBUA3o+1OON6vL/UvZrPQu2a749ehAR5IlryQF+ncKNwe8A5tqpVP7h6NEfu/xs7rha9dtx9qNFrCuyDR5sZqDk9c1oqaMPVJcRIPTdTDBJhTsV6Lkwc/FB+WCBU7PER3HHoHHO++38/3uHPWTQkRHRPhvTfC/gLGzo8BFZktZz0/T5TJHmJ4d8WJA1vmCyX+3OjSfS3qM7T7W/LqvccJU6OFzS0FdL5fqgmSO9I76Agv4hys3efz2XaPKJ0Df9wiCmc2P7b2yaBTGy/NYBAIYTOulKGa+G3Mrc16SRVzbNju9MVN81RoZ1hM1eKchN0dnYxNoGOk7lB9jvckjTE8U9OYYPyMTnVpt2/qiq+UnpPn9/q0k6U4wU+EZNANM1aOZrr5E7gc322cj5xJ3lZiW9/4LtsjV4orhHwgO12D65vgnre1g0nstSOTSmJwlUpZAFnxCLhkytUFhA12YR45BxfAWujuQR95K5oj0N6g3VYFHQiDDUtcE0knKepYkvwrXCqDApsj2lImit98g34j7QcZucCUVw81GesGyJoYqnZDLs+anaTJMtH1CWLZeTt4V846JcZtKLKuS7gxBPRDgZ9ES9Da30OS4n6lyuYcAbrY7YXZqSpPNZnnVV4Hyo+HIXwMerN2YKasUpS2khU1qrt8FzL5uDJTiRTcJk
 NNxZ3L60
 2zgtWPDCj8vCr/2/opA8n91yh7IjjvRD/H0K1so4zYhlScJfg3hybIpiOcMX43wyAKit/tgGGWdBOVyNrl3UbdKkUiGpuVkSXYB08iTO9a+QGIPyKAw83/03MEusyqnyXN8vbpclqIvWGpi6wF8xH7UFQx3dycZK7nZ7UtcRo1ba+P3EFmrLG3aoOlssEU0+TBjpzwgkB5JbLpjtv6UqaksSGRMIkQxg4Nf5NaCqSf6oftttWpgzG+OJoZzkzHPPQAuvgWShXPvj0x8p2tXrj73yNnGmNP0ZjeNIEzw3GM049nOcsCuM7Dwn3gB97QmNEvpzHAGE+KttkvhNWAlp4Jen6q0JQG9sGDoVWHNFwvnXyl/unvR2W5cSp2uNsKoiNQY0OUiSF0B1Oi+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19 2026, George Guo wrote:

> Hi Huacai, Ard, Pratyush,
>
> On Wed, Nov 04 2026, Huacai Chen wrote:
>> I prefer to keep it in LoongArch until a second architecture, and I
>> think Ard is the same. But this is not a strong objection to Pratyush.
>
> Kexin Liu and I have tried x86 as the second user, to see whether the
> common table holds up. It needed only small changes:
>
> - The x86 EFI stub installs the table, as the LoongArch stub does.
>   install_kho_table() moves from efi-stub.c to efi-stub-helper.c so
>   that the x86 stub can call it.
>
> - kexec_file_load() skips the SETUP_KEXEC_KHO record when the table
>   exists and the next kernel will get efi_info. Otherwise, for example
>   on a legacy BIOS boot or with noefi, it falls back to setup_data.

Do we even care about non-EFI boot? I'd say ignore that for now until
someone comes with a real use case for KHO on such systems.

>
> - When there is no SETUP_KEXEC_KHO record, the decompressor's KASLR
>   code looks up the KHO bootmem areas in the table, so the kernel is
>   not decompressed onto preserved memory.
>
> The table layout did not change. The only change to the common code is
> that efi_kho_table_found() is no longer __init, since x86 calls it at
> kexec load time.
>
> Tested in QEMU on x86_64. With OVMF, the KHO vmtest and
> luo_kexec_simple pass, and the second kernel finds the KHO state
> through the table. With SeaBIOS, the KHO vmtest passes through
> setup_data.
>
> So I would like to keep the table common in v7. Would you prefer the
> x86 patches in the same series, so that the generic code comes with a
> second user, or as a separate series on top?

This should be a follow up series. Don't get your series get caught up
in x86 changes.

>
> Pratyush, does this match what you had in mind for x86?

Sounds good to me. You will still need to chase Ard for an ACK on the
generic EFI table though.

-- 
Regards,
Pratyush Yadav

