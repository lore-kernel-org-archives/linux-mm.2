Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9045EB7EB4
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 08:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 220F36B0089; Wed,  4 Mar 2026 03:47:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CEBA6B008A; Wed,  4 Mar 2026 03:47:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A3956B008C; Wed,  4 Mar 2026 03:47:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EEB516B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:47:28 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 934A7C1ECA
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:47:28 +0000 (UTC)
X-FDA: 84507751776.01.62E26AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B04A8140006
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:47:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QnfJO3bC;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772614046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSCXwRN0GZ5qOnkzMHci4Cqa8o5lG4v5yFoMjYJyHKE=;
	b=yASGsGkGvEvD9KFQhzSD48n6qSI9QYDQ/mEIKdhBlV8EAEQV5zRT7Cch2/mHZvuivE8pyA
	96ef4RHZq1FY/4Io9TT5Bl6Gg7EfqbCrvHyV9ZRvOnsKLK64wx9DIeUYTnyS0QOB8r9Pq8
	J+qC/AaR6KWoJZDvJ0xoyaiDxmSyEfc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772614046; a=rsa-sha256;
	cv=none;
	b=PFOOnOLgRLqbLQrvVBML/9U3+k99wUKDCNhngqXTnlmQXOECPGlzhNuhpyWIkMhLyFArrD
	mbaQ5HjgfGdQdUUoWwufni5H2Dx7sctgEx8slZE4o7L1Q3RCkUppm2w7MNEWQ6Wok8816J
	Epd+T7XdxVWwwWe4i/Pe0I3WplSCCSw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QnfJO3bC;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 98C8C40A1C;
	Wed,  4 Mar 2026 08:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC56C19423;
	Wed,  4 Mar 2026 08:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772614045;
	bh=tdnOPIZfhKwu3MgtOaiNYyGgY/oCQPEL0L49OtC0di0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QnfJO3bCLkXPWyO8cJDe7kI3imKwtsD7cZGVY70UEFdPDa34x+pVaNl690XPklP1E
	 9AtGUGwpgVrAOYzsTqhZlY+uJHZ+tEKkctpwu0j/Soj3tpm5N8Gpvt3NwmvsuI6ReO
	 rhrUSoik1Hb0RQspb/+SR3qrjpw76mNpAjP1RpKOE2iocQTbFWwJwFoB9eGslgVnFS
	 cwadH7bOaUTsUEeSfAfUaHMZyX61nvgdjcCDxfmiWcxZ6cNubQACzNViMmowApOjZ7
	 oRjOVcNj6D7TkQG4urobKQrzQcSqBIT53RTYraC+tYq+niOLPurxLmQS7+83ZpggFe
	 bfGHLGWagLUUw==
Message-ID: <65003279-7312-46c0-b7dc-2ad9e925a9b4@kernel.org>
Date: Wed, 4 Mar 2026 09:47:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 02/16] mm/memory: remove "zap_details" parameter from
 zap_page_range_single()
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
 Alice Ryhl <aliceryhl@google.com>
Cc: linux-kernel@vger.kernel.org, "linux-mm @ kvack . org"
 <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>,
 Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>,
 H Hartley Sweeten <hsweeten@visionengravers.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>,
 Dimitri Sivanich <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>,
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-3-david@kernel.org> <aaLh2BxSgC9Jl5iS@google.com>
 <8a27e9ac-2025-4724-a46d-0a7c90894ba7@kernel.org>
 <aaVf5gv4XjV6Ddt-@google.com>
 <f2f3a8a1-3dbf-4ef9-a89a-a6ec20791d1c@kernel.org>
 <aaVnifbdxKhBddQp@google.com>
 <5f8dcb7f-9e4f-4484-b160-3a9ce541d63c@kernel.org>
 <aaWvtn48X8UizaaN@google.com>
 <CANiq72nK8P1rUYw=y3fMzWZR3f_mW2v0_LSLWR1i0dQTtOqu2w@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CANiq72nK8P1rUYw=y3fMzWZR3f_mW2v0_LSLWR1i0dQTtOqu2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nuxnjqe6uar7booa7mb4apxrzd94qowi
X-Rspam-User: 
X-Rspamd-Queue-Id: B04A8140006
X-Rspamd-Server: rspam12
X-HE-Tag: 1772614046-324651
X-HE-Meta: U2FsdGVkX19svK8s90caS1//iZG+Javxad3eHh+DX8+K8A6ekGnYVxEjDvH2hcT1POXf48tw6UeGH48kKqKgCRg3/7Kbmryr+HLROGEmugJNRPlDKWjIltMp2HiMMl2c3Vu2T9k/+ZU3t6gCO8zpPtbjud68siatXt6gsw7fiTmUiVfXzUS0cEcopLYiaE6+KwXrOWUXDjFwLbOT3knd8frQfkI2UVuXSZ1Ek7dr1P1rtkzSN9avS0gRtRV9iqSnD5ZhUI54evhiAdGBIJ8plQ2r4gUCduF2hZZQJOvhXmjCNm8QQxzDY2tofta4ZmgIYcF2QdvRPw6REuDtjOTn+XvYPT+AcKX2FAGOafKda2rUc6ohApEdXfZfhEZo8IpTMDhIC4gtqoVsTnOeBRkOMyX1gdV3KGC3AJ2Eml3gj0+7CB6HJ+T7+oY+Dlpda3XkrayLUgOt5RXGJOcMjzWadfxnvZP6q26khRycXiOkVWtnqkusmEw/aj7H+G4IPHxxer9x8J422BXTOYnxa5gSUHGHbxZx3GqyYvfJ+s+kC3yQT6v8JaKtOnw7SM4+FnVo1tIT9KxIiMkmx9GLPk2Gn+n0AdkIC3gBpxW7D1vnriTcwIC4btOIxU9xnohQgD9v/16KCD+CYMXY6G4oMzbSfgTpByftEK+BsfVjIdmnwn4XT0L68J+kYs5TOZS84b9sJrTGxma6ArHa9WfvAxUO3w3HEzQ93R7SfNFJBCf4TEmpKtaQ9S1jv+nbHWeQRs1zv1wTR6Coar6cBbDR+QTnQiYuKH3+MSU/6ULHPBOe4xCG6O6GBkP7ZwVJ1KQ/oXuNkDUwOcMzAYCJbQI9DoktcvvMkayH/nN+VNBRmqwpb0n6wkimxvdIYYhkYUEMZTgDzKpa7JSM+Usnh9dUwVWnhOhru4LRlzf1faNEwZ7ESwB/7tZkHAdrwFDVbbbJ+E+HnrWTX4SyRb7ZCCKL5h8
 S9U3yUDz
 XoJ03Rm6IopsMUWVjQ1HXOChPZiJ8Q9aFarQI+xhV947N31yjQApcKau1535Kf4uJdXQjBWEwPnz9Tw138+ROXXuoxWju/X9G7iCNx+tzXaNHOpMVVFomUFq4GRqlqHFzRL9mAjN9vC0JKHsIJmLFRPBFWU6VyjIvkL00I5Iqc/M38zwBoiDieR5cb/1AA3C30/J/BH5Z+ttiz8Tyl/FeNyLGurOPq4xpj5XBTmJcQFT7fdIPeVJq4JAN/IW/3nQbhSPJq8Sswgnw1OC3N9xvEIE9Gu6Bk8Xf+AGfUlVNk4KxaALhrH3xiP1hXU2pXrjK6DW8xAhiAu1s1ycG/7YQSuZx6TqkBxo2lu4jTMHvxoJQIh4a2yR0wXkHiGnjB2ZZy1oM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 21:49, Miguel Ojeda wrote:
> On Mon, Mar 2, 2026 at 4:41 PM Alice Ryhl <aliceryhl@google.com> wrote:
>>
>> It's not relevant in this patch, but another thing that may be useful is
>> to add CLIPPY=1 to the make invocation when building normally. This
>> causes additional warnings to be checked using a tool called clippy.
> 
> Yes, please do use `CLIPPY=1` -- the build should be Clippy clean
> modulo exceptional cases that may slip through (and soon linux-next
> will probably start reporting those warnings too).

Understood. One thing I realized is that most (or all?) defconfigs will
not enable rust.

$ make defconfig
...
$ grep RUST .config
CONFIG_RUST_IS_AVAILABLE=y
# CONFIG_RUST is not set
CONFIG_HAVE_RUST=y
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set

That could imply that it might not receive as much build testing from
people/build bots.

-- 
Cheers,

David

