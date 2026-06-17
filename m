Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E9BFCD98D2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 01:10:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10E2E6B0005; Tue, 16 Jun 2026 21:10:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 091C66B0088; Tue, 16 Jun 2026 21:10:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9BE46B008A; Tue, 16 Jun 2026 21:10:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A6D906B0005
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:10:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 111738CFAA
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 01:10:50 +0000 (UTC)
X-FDA: 84887625060.05.E0B359F
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id 19CB11C0003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 01:10:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TfL9Ioh9;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781658648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8vTRaR/pA7ZwYritB+PT1OlFjaCid8Lr3IAk6dJInE=;
	b=n9d6MtpnRG3hNkVqyT8XhF9HjbP0uuJILeGyeyC7IfwgFE0f+FmgmpSk6UuI/EckKJDIgQ
	QzbAXdapLNZOe89K9mJcmN5StStnWE9AaP5E5IHII8n682vItlF4oo3uo9QQmJhJZeYiJy
	Eu8l5FtMwXdzX4hxxzY3EY3zzzjawNM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781658648;
	b=py6NYImKIOqWoY12LLLW2c9S18GXeZp6nMxy5GkWfNJ6tkgRxaPSaVoRHxv/KMURMCsNWF
	gSI7g82xPjEPXDIZf1CsBjkjdJmEr96BzxXwLLEvf7j89AzyAPrjvUAfc1mB82kT6UbFc7
	XmVchYUr5pNv/kqUWlSgpGmyWOdYtpk=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TfL9Ioh9;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51765331535so75541cf.1
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 18:10:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781658647; cv=none;
        d=google.com; s=arc-20240605;
        b=YEaPi+Wb4drIUOggR0w5M6h5Cyx82oSQDwIIkbnYtxVybFkcQ7+YrV0IAXCaBUvqeP
         mKkJfV39RBNH5lG53V8vh8VpMrR7QL7xUywJUqrQCKC4ZaZaDq15vdPwNodPV3XGoudP
         WrzdOTv1ubND0TOLxRR3KmjYiPPMIw5dFLFaWfURanEzFzIEA+jkJA2A3LS+/WuI1aoP
         eVLiuOLeN32lnA7zjSzEu4TWdt0cfqf4m5tSbwb1UKnZga3CKup6Z5blDa/+CyGPEtPo
         h2FoXfBERGpubAZe0SZgAPpTEqe3CLjaEb6hIcWPfvh2pz524UXAMFqZ2Y4o3D2UA+J1
         IcuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g8vTRaR/pA7ZwYritB+PT1OlFjaCid8Lr3IAk6dJInE=;
        fh=RoYIppHIl9jve0nCaHgO1DHZ1toGC9v4UfTMcWbx2js=;
        b=OHb1IuZ4ipoJ9taj7aomtXDlIgwISz1FJF8A0aF27wbkzHMgdD35u6XG+rHiyMl/85
         wZcuLWLkiz9wH04+kWicl3at3J6se9VI7EzrwFht4r+QaABOe++Eb3wCKKwn0iQxRedC
         aAlj/+OUSDGRWhmMMIVI4o+bAfiBCswCZbWuCuvgzL+NJa0BNtVFOH9tont3OLeQAsIn
         NeNN3AVN8Yvy5R0ZNqO3wdtWJmXjk6RTuDq49D7OuF9ijgouLMaXNmGbgZwJA7kFaIQc
         kWIBEP+A8ww/K68t4Db42scklqlEsCeIiIuaL0D1YphxXiwxpHgFJUlfz/V4HGgZS8Jv
         iZfw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781658647; x=1782263447; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g8vTRaR/pA7ZwYritB+PT1OlFjaCid8Lr3IAk6dJInE=;
        b=TfL9Ioh9lMYRAoD+Iw3qnIBJnQROVXWRqzj+5LY5uUshsKdq/uDoOhBCZdWwoZD9bQ
         m/4RTMLrZlHQmqTAm5J4D9FHUtaKtWEsQtpPKunMnFuT+BPpXwVSgIYiZ8MBhFmCNgm4
         flSRxwvVN/Ia3vqLoC/7oMX2fIUIIAZ5cDEp+ltGLxhuxC7dE3UdDbpCfU/YqCllUWpN
         FEiMeEy7KYvFXAoULzPghrrm4XqfBvd/YOcWgvT9rlSBdpi7wui8kIF94uETDX1z6XgY
         2KpThgx6miez21/Mr4yP1NrHTjUs6nZATGzuWBIKHkdUxyufttrLyj1i9Tklv7sVn6za
         p73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781658647; x=1782263447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g8vTRaR/pA7ZwYritB+PT1OlFjaCid8Lr3IAk6dJInE=;
        b=SRa/t2u6UI87W2vDfoo4NLgOJ/9c6pH+vqOZk5QMby4799sSFLn009XqJWceFcN0ey
         VPIQIr33CJb2uv5vUZtw2wz9bLrzU1tliQO8S7afvGqoRQFexoews8yI08LZjuuu4kNy
         mSwdYYHXqDAghMyyc98/q60MIWuHycoOkCrudqnhOs5kTdCAEIOcsqlKqoa9zZZL0krM
         tP3ddO4+68n/bHJMXQx+bnbqwt35Jw2iKjclRy3ivoE7g7O+N7a94tdEjYaIb2fysfvi
         r983nRbvQC3D3zkIjoX/Fx1AiSGk2AElOZb1bsraRZoP7QJwzt4veFXbd9Ts+PqLST+y
         CkiA==
X-Forwarded-Encrypted: i=1; AFNElJ825iDmk4IQoIiuDkz9JW3UDHcGuJpO0EU/E/JnWLphDeNxqE0lBW2KKNaVTY3DUjaGwZPAjGsBsg==@kvack.org
X-Gm-Message-State: AOJu0YxKBGg8KbhUYl2JhjV1+xRM7RH7prYQucY4iD8iGBMivorC6Edd
	NWpJcdGKYn3g/Gd+U/09LW2aq/dCLTDa9eA2+Ckvud/XEaEKsh/BDZkNIahTiQ9khNiUvK3JgPu
	0B4V64pM9XaIp0M9uSezdgGJ7MOVZnG2rpwUYqGNQ
X-Gm-Gg: Acq92OH9f81new3a7tXzvYwA3bVwk5ZJHsibW3hilsOL+sl6nWsVrTCuR0YIhSpTDLD
	OAiOoZxBCROdAcRoojsol8QQKrny/c80IfSyOcfgo/SHOe/faMpV7eAZup8oZ1yL230nbpya77P
	ri/B4JdWXXcDOj+jRYE+5NDPnV0w+U6zf6mBvJkXohxUo1OFIT8DhV4lBuZ4s/MoKOT7A+88tRZ
	TLh9roqAg6NoEUFsX+TdpFDrE9xdg8F8z6gw5y/5lcQx5iSRpEcCezsYPFwZm0mjhhhhKWo19Zx
	8k5TLQ==
X-Received: by 2002:a05:622a:2587:b0:516:9871:9a37 with SMTP id
 d75a77b69052e-519ad7f9dc0mr2778371cf.3.1781658646471; Tue, 16 Jun 2026
 18:10:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260616190300.1509639-1-riel@surriel.com>
In-Reply-To: <20260616190300.1509639-1-riel@surriel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 16 Jun 2026 18:10:35 -0700
X-Gm-Features: AVVi8Cf0iwHJ8U5Flz_etgagn77f-YLs-fCLVAm7q1DizBt07IX8qqwkZnN-d7Q
Message-ID: <CAJuCfpEKgiQDGXgCKrqnn7Wk5YrT8nr4-H88PVeEruSKjtY_CQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm: __access_remote_vm with per-VMA lock
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin <d@ilvokhin.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 19CB11C0003
X-Stat-Signature: z8pngwp6wt3zdpr3aue7gmffb6wp9k4t
X-HE-Tag: 1781658647-495705
X-HE-Meta: U2FsdGVkX1+BlAixgcW5ZMsBXZca4WWrRZsx4xFo1ZQwR4UZWBkfsarmFfmOLF15M9AtBhHOMtF4mFL49onZCL2ivdYOwi9R8cyLkHs6qs13t49chLS6VJ2OXGKj0ESFfa1oHcHKcKKsSb+KNgxEe0Nu8JRfWlIc7bMY6e7IJzVhNCK/TBZEO/tklaotBkJr5dETvxMZK7nYXaWI1bfl9G/m/1FuaJynd0LpR5UUk8nXi0JiUWezlDX2rhB1IEUJnjQTzsNfBvsdxtqcSlk6f003WF1eIfmEm2Wx5cpndlf23XBMtrKsZAqBlIOIyDkQUy647tftFXHmBc1HScd3fA51E+b4NYF9T9EaQg9TScmyzxA460VMTbrv8mPwZITZcWvOwfjXsD8kKNLKn2vQqwMzdeunuxICIj2XrYo4eBzpqW//zzR1MmUlBhdzuCXncRESZDrlTuKhGBB/oW+6mJxCNoNeayfGa0r65/7wtegQNw31adYWFjK33kFNM9dXWhEq9O6Ff5vOZSIy2YviROPKrfB/dqeAB4ueZVQ4cqcHmCYpY40l4cef+oq/gGo45wVfbzx6WOQDCpVgb00ffbzVgnEk2GcrBb/8MOLQYc9DxgJ2b5Rr/9lwfaHrufk1oosa10zeW/rcNcDBSJ2qkmTxwjbZnZgeYmS190jkiTRwngSmDc4wjYJaxJSGOHcVnPfjyZO8Igb/jgpfUwSdLBBQ4cjZre0mXGs8gtaLL6Ur4QzncX3qlPtHDuBhjpDYIWDveBxDCL8D0UI2+lox3GHeZ6lcVK7AQNcQXvCHrVQmRGOt5bNQ6a8xdnKLfLdARSclQBraaxMHoHvCsU6+8iw7XPDqqghg8QNPK8xfC+QiuN5qSbXrEWYygvUOtIcFRbYfPhMIUVrmdHq9d52WfG0FKRsggSrPZ12d30AFIhUHhqZs+B46VQHKqVhovUKo0JN8XkUspXVKKSYudmS
 bQigP7dM
 2xR152u9XtSXupKZ+5bt37tiQQTyoWys8JaPa+0wbMuzx2iCxDps2HA4bJEFNRwuAngenWj4gtLLpWyV+pvs8oB8cA3J3dywsLAId+SLxtM2pNf7iGtUs64GRilnLgGR/XRPQGzIoKGokH2h6OD9mZ6/1VKxDG/jo6j12tLOQ197VcT2rDRiqniRhwuGAFnLJ8itmoU96sevXgd5U40etlKsEyyT0Ix+KBt96oXXj46jxhfX13Fn+0Unhni8A4LvVd5zCySmP5ETr9XBzAhw6sr0N/2yeFZDb/N18s1zkNlWm6rvy/FVC9PWNNlsfu+RJmjPIW4n17/IwdLflCasV/gItx82Y4XDWLORVt5bu0GQsQGeu3BT26393x9ob2brv5+4EliJn/GLZRUvb7+wbx9JdJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 12:04=E2=80=AFPM Rik van Riel <riel@surriel.com> wr=
ote:
>
> Sometimes processes can get stuck with the mmap_lock held for
> a long time. This slows down, and can even prevent system monitoring
> tools from assessing and logging the situation, because they themselves
> end up getting stuck on the mmap_lock.
>
> However, with the introduction of per-VMA locks, we can improve the
> reliability of system monitoring, and generally speed up __access_remote_=
vm
> under mmap_loc contention, by adding a fast path that does not require
> the process-wide mmap_lock.
>
> This fast path is only compiled in and used when it is safe to do so,
> meaning a kernel with per-VMA locks, RCU pgae table freeing, the VMA
> is not hugetlbfs, iomap, pfnmap, etc...
>
> The code seems to work, but could still use some more cleaning up
> and benchmarking.

Thanks for the patchset Rik!
Previously when I looked into using per-VMA locks in
access_remote_vm(), the biggest hurdle was get_user_pages_remote(),
which required mmap_lock. Your implementation avoids altogether and
keeps the code much simpler than what I expected. I very much support
this approach and will start reviewing in more details.
One question: CONFIG_MMU_GATHER_RCU_TABLE_FREE still has this comment
about "Semi RCU freeing of the page directories." [1]. Does that
mechanism being "semi RCU safe" pose an issue here? I'll need to
refresh my memory on why it's only semi-RCU safe but you might have
the answer ready.

[1] https://elixir.bootlin.com/linux/v7.1/source/mm/mmu_gather.c#L236

Thanks,
Suren.

>
>

