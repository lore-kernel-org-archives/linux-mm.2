Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B37B107BCE6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 22:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E8F06B0088; Fri, 13 Mar 2026 18:39:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596A06B0089; Fri, 13 Mar 2026 18:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4785D6B008A; Fri, 13 Mar 2026 18:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 379A26B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 18:39:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C03541C2F9
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 22:39:30 +0000 (UTC)
X-FDA: 84542507700.03.2D35961
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id CE85240010
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 22:39:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NCzhvUNy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773441568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MXpnJgNd9wve0xok691+KsLsOIVO5aHkrdME7CbtZs=;
	b=J5kuWN4vD6D6r2uvz9IngSwsGuzaY+/wJqGGvNbElAf1wFQoQCm5hFJlsesn1Dsa4XKS4Z
	iwWHO3xEU7P0wK9mGWMs/Pb9h1RTsmnBCRtEvoxOqG+2U7ss2bT9wPmRPmXfLyzTThqg/W
	2UtG1KX8gB+fPYN1+yHroJTPK2sFIIs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773441568; a=rsa-sha256;
	cv=pass;
	b=CoV1kxSLUN/UFSgxDCCjVVbdK6rPVm7/SuM2tay1US4cuuaUzEFHmO0WFY3cIs8PpmJGeq
	qZEHf6pYF1WYj+p3AB5C2CxnnN18pDxdoTjzEdqtG/pvYyrIDpi1q8UOcdDGhsfpokqSi/
	LdVEIVwcai3PpQ6HtzgrhgE9kbmZopI=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NCzhvUNy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1277863a912so145938c88.0
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:39:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773441567; cv=none;
        d=google.com; s=arc-20240605;
        b=lS3bJyNfROwBFinT3V/xXOoRvDUFNewZObM/7vwSUv1EpMPBVtw9Ko/drFlVF1ehyk
         9JBj7yTK1DLQHd50YcPqDMbWKOPYH75Ml42zbvuwwC7ivZvtTHDf9275xqQ13Jb2Ud9B
         h3wEQl1lcV9Z3LbuCyzhfAvWdaXxIzvRmSxjdcUlCKXmIhO4i/UrxcequQdi6JtfDUME
         9GPcTE6P9jnjp9rtb2sCgK8WvHG4q2ZaEgt/t5VwK3UsqUCKWK2uWHWAEOLrD3zaiLTH
         8r180JayEemJMQCQ//gt6lsUiV3VeUx2dluGDA/WZSl1/zVKxflRuVZBdS4fMsxIClZt
         VvXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1MXpnJgNd9wve0xok691+KsLsOIVO5aHkrdME7CbtZs=;
        fh=SIxzdrmqsjk8b30SD8ip+YwF3LADNyGHChCx4Bs2pJA=;
        b=D764BVBUJRhr6+6yBV8gD9jUlba/3MEPVuS7+FR1f+0FVarasC0h8QvGTdYfHjevN2
         wQjGmBo61b25XQikXUR9hltj0KqVIRa7uNOrolDu0qBBm6f3Wc4Y7JwLm89P4JSPH8Q9
         kM3qGBMA3xSBUOIfmL5RVuvHr7NAknbVGFohHxrnsQUCLyeBnx7b1x+OmHp8Usrs+x7A
         xYN0dRbpMS+DNXyBenxwa9nD/KdFvbKNTApBfzQdTyayh14qm+gl/fpzpfZ/WOz/f5Ai
         JGJR4q5nJoVvdciRgdrxDyb+cPJvqqBre/iLc763ZA1+eUxPAcu5I8fSynIjk+XnUPyZ
         /ZQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773441567; x=1774046367; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1MXpnJgNd9wve0xok691+KsLsOIVO5aHkrdME7CbtZs=;
        b=NCzhvUNy2me5F+M79zFpPI9EQ+v5Y0eYCeeXM0fav57mLAFJDQn8Eg8f2pu18Km9lg
         L/05Dpp5xn2ecprMLw36DOMFCJa4xcA2DUmmeHRweqiZGkxLGQXxDR+/X/rfuqkMedKz
         Dw93Dvt+mgda46Hq6VMaCBgF1j9qtYIdYAVPlq17AgYAwymO452O4VrDQX72F3/PujC3
         oJ4pXxLIdqNAxcuWrc5NNe+F+YFsZdP0Mz4alKzdozOBdTPuBtw9Pzn6Tyqp2t1pgERk
         FFsZfPrM4D8pXxGwLzAbvD7O2AyNJGuyavrWdctJsYSKGway1sQyTQBK/yUXHo5M+sO5
         iT3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773441567; x=1774046367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1MXpnJgNd9wve0xok691+KsLsOIVO5aHkrdME7CbtZs=;
        b=agbEl+NDtvj0XlUrtaNQo7qfthrGMDnKWfYP6EmfxhqnU/NyMAWdO4aVLKczMZJ08A
         UaYldsR1R3/OW4B5QcXoFhQ8TJtXaLVZwcNaA7rM6zqS6/jhniGdXepzgpAruq55R2nC
         7+TuOS7KEdcL+qZfDPlpowv7KggZXsblv2x1Oywv12TGgP907ilTrpqd4e1BMAlF2wVS
         jq9RMNoy2iyH1ohFsgZ6THaGG7Cgyzb1Uz8nFTUFNiwAYUcVZ1KrUGCfjMUUpdukcOX4
         4+LYbHSwM6LRjRyXrIa2vMBMz+6avZRktZbhDzw0GradupdkS2Q8YwT6haComRhHvjQb
         qTRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCqvukuqbtXPbI3YM5UfNha8LVl9qWdFtaIjZ2M9wHEo5mtpvv/dom/k9/KtSM9sR5JmxMbR6pXg==@kvack.org
X-Gm-Message-State: AOJu0YzS+Kg9Lw09hr/QJKdw832np293/gwp2kX0WV65LBHKfc6oYpiP
	03OjJMnkMTDmrYXJyhupbR7F4hCEY4UosdufMXJJgBXWoRjTNzBTvxD9sJn+udE793Y2mIGEquQ
	fXqiYGv4j2PzFeH+00AAjgwMxCF8ZxLU=
X-Gm-Gg: ATEYQzzpyqKpbhgQ2P4dds8C3kw8uZO8Fw52yDEXF3ad7HopN9cJyQcna1OujzVnyVV
	Fi4UVF/cxY64wqBag5pmQH4cURKUYkNLaqAobGmdvRcYPnQ7WKnLxFqUZ4Ujxet+4Z5ET8JmzlV
	vqGqOksbLmBseJgwt7PIyMzWSMw2jC1xdQYyIVxNRiXwTcv25IMG2G1NXA4pasdvsSpRWIDR+2N
	ail5CTGwy8xxpfSGWz9wd5FWf4CuqglT9wNgqPSdHXC2K6rnmTbaXt9PWwAn5tkzP8CsQubKdcz
	9/AqTQqMDwxMTjsuxOeO/D1Ln+Xdp4iPP6hZ13GaVBYcmhcCnoFYt9CCxdE61dK84/U0fLRUtzp
	w41tpSzc1BE2wRh6VmAk4KOw=
X-Received: by 2002:a05:7300:fb86:b0:2be:e92:7f44 with SMTP id
 5a478bee46e88-2bea572033amr1222141eec.8.1773441567469; Fri, 13 Mar 2026
 15:39:27 -0700 (PDT)
MIME-Version: 1.0
References: <202603121235.tpnRxFKO-lkp@intel.com> <20260313213638.GA147391@ax162>
In-Reply-To: <20260313213638.GA147391@ax162>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 13 Mar 2026 23:39:14 +0100
X-Gm-Features: AaiRm52mq6KFRynN2HWB61zFcs2DGJMHqt1i6x4Cnd5DvVDH6nH69snDO17l0xg
Message-ID: <CANiq72mzEzjNg7O_2dWT_6QOJvJ3TwV+HyxNd_F4j6v9C+pc7A@mail.gmail.com>
Subject: Re: [linux-next:master 5585/5731] error[E0277]: `*const
 kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
To: Nathan Chancellor <nathan@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Mike Rapoport <rppt@kernel.org>, 
	kernel test robot <lkp@intel.com>, Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, Mark Brown <broonie@kernel.org>, rust-for-linux@vger.kernel.org, 
	Miguel Ojeda <ojeda@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CE85240010
X-Stat-Signature: gdpa9k3ambatpo8pa7aasgua6tgtphnm
X-Rspam-User: 
X-HE-Tag: 1773441568-866246
X-HE-Meta: U2FsdGVkX19bOdZaPt8Z9dyQw7Xj12q+j3nxNEno89XBqWRDQsrexbG+fYJqo8cLeWqCbq02UkCcdUWGKjBgJwX4DsYadCLDq26WCrjWvq6UmVISkUmBy8Z9mWupv/f8hQS1HWQ/CRdmadaiCauGQoRdIXL/2VkiK1x76heMsIn/Eajae0raQERhjP4lqrHogHva12YtT/qVsdfVajFxRDRmURi3zTxnlxP8b1lhhggBdiltOyI3V6sgUSJGhrTGuqFIjWbOTOtybQpbwtuiTEKVxZwEewLXu62m97z/z3f9RQ6SqUe/9Ny4iGYIeL1dGM64cRDHI4q8ZN/SqM0EFXeRcirE98xWskeHbx3rLxTWk8nXlZd0E376tm865zUPGB5c2P4yFJzpItROm32IsjoWtqhRddjtXxgeYEtJWbDKTdMWU5LIVS8/kq6UXGXVPfPgoBwR43VtALtwtaycCoBMsZps1i7D4IXlwEwEJGEVKfCqwBJSZCulmfzS3zwz46Hs0eQ6ioUujqcRLYWmMiL9oOBLT2+c7Eedicr3TMJNTctTPF86g0J65uMQmWnhKQgVbMDdSvkKL3id4YyYM7o5GU9nU60o4nXeXUw8HWJbOr/F6jp9Kaw+vJkmCT5nuDqYNTKEUPKdiJ/QCO7khtLpGcptdwg4RfFUFfBy9BIfyHzxWYJnoqw2cb6d3N7ZPwWKv+wkPiG1fDh0XtNqF0Zzh4jpCKRARHcQ0v4ThIH4xhn9/bOcKQX0M5DPD6ttb58mUkt5l5Zu2kohMnXO5MKAv6iKDJbC+pWT8KAdYCzy1V+lRLpexzMPKfQj1obmqJW2CXAC4ZYmsB/e5Dn8YbFd1AzDhzy7zhraalCDLvbkHNVDzdc2v0h4RNKWtQYDzVofuJati+j+RN1aTd+i+sNlSQMf4udVPkVNHMvHPyOzb7b558S1lOMdhhQJkpDUx6/YBHg1AiwBkZ9LK9z
 TaC30n6s
 aeco6GQ6t5W2GdpFY9BIEFrQDM5ku32GBOBVpGzzIqjFty90zNokQ2tBGN8Wk+t+6BGUrP4RC1Vz2UK7sGIUghDuMLPmyS/0SXxAreLlJiNZyYEpNfUR5i4zYRiIRbRu5MiA/C+Jfo2ltRTPAbpZhzjuHEtH40vgtVggLIiEasffJYSbgnTCLVufNRo9QUKKdzxwmSD6ZzW8dImEHnysP97fZlk/JJnpqgMmt2zT/Mh+FqBTFCgg072V4QIWHYfYFZ+kgdXNxppTcBY7hfJP9zm/DcYGdxgSgdzq9XnClGchzgmeFlWcQkFjPw6fh5CoiwKAACEl4ziZR1KObTdQiHMtc4MwfKvJz3PRcTnkWTRypcByVNRWGnRvg1ZpSD4ln2adcv82U/cfak9NDAasd4nJq97/22li+dCqfPzq/oOj6B0a80cbDOcPQrOCkH0MB0VGsLh9eN7e45hJiHFbdL/b9SCwjyMixhmDQDcFDY4RRQJT8KqD8Hf5l/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 10:36=E2=80=AFPM Nathan Chancellor <nathan@kernel.o=
rg> wrote:
>
> It looks like this is a conflict between Alice's "rust_binder: check owne=
rship
> before using vma" [1] (currently in char-misc-linus [2]) and Mike's
> "userfaultfd: introduce vm_uffd_ops" [3] (currently in mm-unstable [4]),
> hence why it was bisected to the -next merge commit.

Thanks Nathan, yeah, adding a raw pointer (not function pointer) to
the struct makes the type `!Sync` in Rust.

I assume this is best handled with a patch on top of char-misc-linus.
Perhaps creating a wrapper to assert it is `Sync`, since the
`BINDER_VM_OPS` contents are unused (so far).

Cc'ing more folks related to the commit.

Cheers,
Miguel

