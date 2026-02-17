Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 070CDE909AE
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 14:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 455E56B0089; Tue, 17 Feb 2026 09:45:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB736B008A; Tue, 17 Feb 2026 09:45:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ED896B008C; Tue, 17 Feb 2026 09:45:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 197736B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:45:34 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCB711B3DCC
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 14:45:33 +0000 (UTC)
X-FDA: 84454222146.19.1CC097D
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id BFC8314000F
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 14:45:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NCQ7Z1Hx;
	spf=pass (imf26.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771339531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/u7uZc7jD35zWuHRH3TBmkuy1kyuGW6IWcfflu/14kA=;
	b=XJqUHRifyohOUHb+8R+yAJXDnWN+Z25UaaXsCkYN4aMM4aVbQn1W3Dh63sJWf7W/Yc1nCQ
	zidzwA4h634MMO80+BHACkLa04XLSm98C7bkEYmiwPCkd5Xi0HXKPAp+evhPohpGDnsjxP
	uSXBzVa6jpPiqKE1fuRkmOUnMopRPHA=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NCQ7Z1Hx;
	spf=pass (imf26.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771339531; a=rsa-sha256;
	cv=pass;
	b=FvGgVU1bGq68RT7f7s4kqe5dGRGvuqmGi4oRypW7EOnsaAGr311qPGF9jxvyyJqHgSaDUl
	uUwSFAkU+abvTRzvh60G/xQrlqjzOEGW47nWmXB14huZP7Cirw4l1DOYNOFyZOfoLDOutf
	4U+hEq3hccQSDoSAIWnHJkQz9pdODoY=
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-3870df2331aso55487671fa.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 06:45:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771339530; cv=none;
        d=google.com; s=arc-20240605;
        b=JIZPfiMGyTn130bTmPzT+DGHDFpMPZRUoLNnSVe2NmIsZ/THrXek5lcKv7rHq3SioJ
         V7GFl3wgTB5+sM6CbihW7FsgHKLW3QyHYjeDUPxskkXVxBcVbTaOWwU7sFgnTWXa60gU
         JIASTDcMjZ1WtHCtrkgETHgAEZ89qTA/J/3UFqs/UdVRyqjP02K2/Lh8yGT6S6coqX5e
         wPqjUZXEOa9xh7CVVaFzEmliqNrHlI9Vj3+h1uo9useFegYG1qQtxrnk1oEVc3JDlKbp
         KsmYZJ15l5hG2lLAKqInpTJrO/g8AkRHz5KnYasHwKPyAMKDPtuUGqOxE6hvU0R5nIi4
         8xmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/u7uZc7jD35zWuHRH3TBmkuy1kyuGW6IWcfflu/14kA=;
        fh=LAzxr626ZXJq0J40RAqCbnC2RTllFb6YNUuabr+U+VM=;
        b=lK9wTg7oE1u4MPlbnVj38Jkd0ZCKRa4fkdgAJU6HnEEypQ9BnhJJKS5FhDSng7rooW
         uf31PBIz4BOxMJlrRKWu52CGq/C3rs3nxIuw6t4exMaLwo7GkMir4FCRV/LQqXWpITvP
         ya6Zlv7V7j4h1i9+tpVUUEuWW53OekpJ8aEFG4qKbV/hEtP+p+/Fm3U6n83i0blDCAxE
         XLCGaSjE3AYiQl4rQaHTwqQbBl3zkhkzs3nugN6s9KWRd8wr4T4LsPryaEAJXnn7ePU7
         piDZHR2OQWqvRy3oduByD9j50hHIRxXehHU6BwluvNPFe1lux3m9MYNzZQ+FRBm2trim
         dmzA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771339530; x=1771944330; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/u7uZc7jD35zWuHRH3TBmkuy1kyuGW6IWcfflu/14kA=;
        b=NCQ7Z1HxV0qcDVJOz7MAIytKRUtrRhhjZSkfuIGon18QEkBJJIp8JR9OLxdzESvfuo
         aIoP+rtsfjawhu54WZlUt4U2uaXON4uLBWwUr5LOt9jT1HNuzEJtHkApdfx6lW0g36Yg
         dBPIHy2yaFiDZZAXE5ihJ0iQ0cw0Vps2tvMfs82jyUFCwyPSqvvQGL0AELlZnK69hYXG
         4z5E2nbdC2p/abkMAFqKTVJKnBzCd2T/RRrFW59qlk3aCGz4qGQxndeaLXLnKNx3br5B
         yH+yrGrUP/J3HnV3qi6nasTf2A4KA8MGbane6bAzYc9ZAkv8g/4EAAFxAo7Zvx4AII7+
         OW/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771339530; x=1771944330;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/u7uZc7jD35zWuHRH3TBmkuy1kyuGW6IWcfflu/14kA=;
        b=HQmTeopvBRREWu3R48VNSWT4mTmkPTizdAOk6l7cVBmghNZX9fX9KVwxt31uBaCOiF
         UNvSTyd+XOQzmv7S11Vm64OWilvZJ9l1JaxA0+PugcDWC0QMhDh7wvB0Gb8afEV7wmNZ
         jyOMicOetw8V5YApPqFxRB93lUefL6qYpzW8+pVV486DK0NpYKd2CJ4JEqY3mfl8H0U1
         /lwBwQIhe9vozGT/yPMTdXExcwZgnQINOvuofRJzJGNRh0V0wFNJMihp/2lHuud0YfXc
         9cJ0YGpRVzUGcbwBXTwoieCcFE2uZh0hd2rd+b0Og5xB1rcqG/fAl/79YCGeAXlKo7oN
         vY0w==
X-Gm-Message-State: AOJu0YyYGB5pJs+BHryal1ZCJIPab4p4d85HzgFFTMNY6Y63Oa9MPtqq
	Eb17jf/9M+kJIpHk+pNO/mcJwk2gVDbbuaK8LZgnrx62JGvDeHl/o0PlUx0Fxs1M30+mLnJcNgx
	Z7B9YzKyOVs/aC0WED6ADLm1yibsSw9o=
X-Gm-Gg: AZuq6aJsw54s/++ydyLnOm8Je7gkD+M4MBJ/9f9Tb8gZ0YH1L3Z7v2QkKtjbRTumrDV
	umct2AUCbRz52xdyOgHvEia8hiKo3PsgjnEgCkzBJ5kaYC3m+sQebp4pxVia+C5Qec86qeUkOsL
	5YfWIiBYKh81fNUpOQnVrLFsCWGUPVVdq1cXG/14kr7m/PW3AT1uEVnQG3OdXQuT2JkW8NtT3QM
	aDwD126YhoVZBwd4oncKYnYM/GZZrEglBzVQPIf0MZqmDuCpsxC2IsHz4zB2Hrg8ctaupiLECqj
	EaemHRDhGf40nhnl/lRwWs+U0PDjYPy7aZTf/IMwVgsUkZt5xNspXNJOMAqDwKgm+UCme0VflnM
	26NPEWSfWdIu3cGTYsg==
X-Received: by 2002:a2e:b8c4:0:b0:382:4fcd:66a3 with SMTP id
 38308e7fff4ca-38819d32634mr36440621fa.12.1771339529478; Tue, 17 Feb 2026
 06:45:29 -0800 (PST)
MIME-Version: 1.0
References: <aZRncP-sKLLS2K1U@macos>
In-Reply-To: <aZRncP-sKLLS2K1U@macos>
From: Tamir Duberstein <tamird@gmail.com>
Date: Tue, 17 Feb 2026 09:44:53 -0500
X-Gm-Features: AaiRm52IVgk0DHKj7FtzDxuM09qZBpdtFqiGf_Kkv53QRe7PSQMWUtp5YOtQLb4
Message-ID: <CAJ-ks9mhOAgNKjepUOS918q90JkmyqVU6axKt-v35Rav+MNy3w@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Evaluating Rust for XArray
To: Daniel Gomez <da.gomez@kernel.org>
Cc: linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org, 
	Alice Ryhl <aliceryhl@google.com>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Daniel Gomez <da.gomez@samsung.com>, gost.dev@samsung.com, 
	Greg KH <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@inria.fr>, 
	Kairui Song <kasong@tencent.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: BFC8314000F
X-Rspamd-Server: rspam02
X-Stat-Signature: 7u9fpg84mtcp5548xqojymdn8hurs6iy
X-HE-Tag: 1771339531-748770
X-HE-Meta: U2FsdGVkX198Nega4GeLdlryMj4FsbmGkFp/dGBrdXTrLf6EpKyPzxIUN/iY0q268f9JiGauea9OIPhn9e28KeNIw4Mi2Kp5qmQLgG+HxaML16E8O2NEhDW2kccmCANUZNyY+MEMs98KUxZswLvpGmk04aUyPo1Gc/rgnjt/vAJV86zANn0Z+H3MEflcVgY4hbmNMTRQZQ8dpimtgQEGF8nN/U4Jb56xQL7n+ttzGrWX7EclteoqMflhgjsHe+vb8MA5VFoXrsmNU9i77pjoeG0i/I0ia6UCLAYTMeemGm95tImdcJmLMWamMSsmuYm5+M0V/kjbrZHP32UZvhmPsS3inxTenG4eJQtjABWSC8bKz9IMfqLrRdncufd7lPi+4sb/nNYhQ2XhDZpQtPm+PGG53nmWUMyemiRUfs0+PeWzmectfDYmwBBAmPCna8zdKD6wuiF+KUxCNIhQ+D10kVwJC4YpH1cU8F4NOgaLbLJNrP/pGtlAJxTwNW1AoNDpCBnLFq6p9Bh1ubLnXxKrtNBXDBsBqEzluBwbPBAeZnOWIg2V7lxlbeA06AcK7PMX5nLCALu+MzzfBu0tdikEh98FrNm8IAsxTh8mq3jOyP9ZOcPVeylMUImTFthwSBiWzlpzzOBmpVegXWFrF85dhyUWcDzyd9Q0fWbytiGAe+bQex1ZeKupVag5NbMGQs4pS8Em4nQHZiXpkr+MP9NERG8McD4du1v0pK+t0TfqkHUCpNiIXE39xJgNCWl+cwdHGQfQU9vdpVhQSfpfeLi1eBbdLmESbB2bcGOQBNRQ6hv5mL5wi59diA+Cq2VE7EV1s9nrG/8ga3U5zWZsJ9Y719AtFv5YoGsAo9LrrtxHl7zyjcSrsYI3YVB7n2KmXTniecRROCbmOh38UZIp4VIf13K3FKA1cgnWP1R2TbYpwuwcLfvlCQXQGkqZlOvgwTEfDfQKhQ83b8uR+o8/PVi
 rPOzfrpu
 fsmb1UjnVOs5RG6Srx5wY2nMd7LP4Y0S6rKR83Yc3PsBc+kr2SAGCCROQzoARWoy4MjowmkRfpUNXJJ5Is3DLTyAdVV8B3tvD4O1adjWrZQDqfXgawEiqW71nvO7ER+85E80oVCnBAqDHlNzC43opTN9E2XP6TNYC6kJM2Usafix7PumLMqXdqdLDFODQ40ud0BQ6QxIHTuLp6R1bJuOAQrF6PntXnnmHkBbmJcBi2vSb4Z8xp6AShQxKir6yU7t9chhoFF6MWLO+VCYXECOPiAvnpcxszhbMIsAVZI4L7MsoedYxrtFWAjgJbyza31HmE0loddDkMHAw4VG9vvx+vJt8xj+K7n3zgxe1SQZlmw6L7GWmqhS6YZIqNkjUSoaPQkLIgordbhgktpmo98hX40IpbMUklWtrSduG2baArNvqzi3w1c8rpRQfGYK54z+Iv85VFwcMf7UIRSk48F+PYvX02IWo2FAAHnuv6aVbzCWiQUktFHcNFGRfRz1o/NPl5Wf5x1tEt1yr8oS6stjUGeDiJYs/NMB7ne5dvuwhTvvVksfUfu3M/a7pKmfb9k8mt+OAe5GQ3Mdwo8Q9CvnQ0rH6NTb5d/Fxa0zuEdIIS5H6Xx8qitZ9bxiD2CoE8Y9OQ6AR26IYe/sNkt5ZcRMaEzhR5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 9:28=E2=80=AFAM Daniel Gomez <da.gomez@kernel.org> =
wrote:
>
> We propose a topic to discuss the potential use of Rust in core Linux
> kernel data structures.
>
> The XArray unified the kernel's radix trees into one API back in v4.20
> (2018). It sits under the page cache, block layer, filesystems, GPU
> drivers, and dozens of other subsystems.
>
> We looked at XArray bugs since 2018. About half are the usual suspects:
> races, resource leaks, encoding and overflow mistakes. The kind of bugs
> Greg says make up 60-80% of kernel security bugs [1]. Most of the rest
> are complex logic bugs where Rust's type system may help but cannot
> eliminate entirely.
>
> The motivation for our interest in evaluating Rust for use in the XArray
> started with a bug in mm/filemap.c that corrupted page cache data [2].
> Consumer code called xa_get_order() without the lock, the tree changed,
> and pages from wrong files ended up in the cache. No CVE was assigned
> to this issue*, and no reproducer outside production existed before the
> fix (a synthetic reproducer was only created [5][6] after the issue was
> escalated). Kairui Song's refactoring and optimization patches [7][8][9]
> happened to eliminate the issue.
>
> In Rust, xa_get_order() would be a method on the lock guard. XArray
> users would not be able to call it without holding the lock because
> the type system would not let them. That does not help with the complex
> logic bugs, but it eliminates the class of mistakes where the API is
> used outside its required context.

These benefits are compelling, but they materialize when the _caller_
uses Rust (and when Rust abstractions exist, whether native or
wrappers around C). A stronger case for a Rust implementation would be
justified by internal complexity; IIUC that was the motivation behind
Rust Binder.

> We have a Rust XArray prototype that implements core operations designed
> around Rust's ownership model. By the conference we aim to benchmark
> it against tools/testing/radix-tree/ and use it to back the Rust null
> block driver for A/B testing performance against the C implementation.
> In the longer term, we plan to deploy the Rust implementation in the
> page cache for A/B testing performance of generic workloads. We invite
> the community to take a look at the code (when published), which at the
> moment is rather simple as it only covers the core operations.
>
> We know that Rust is not magic. The first kernel Rust CVE was a race
> in an unsafe block where the safety comment was wrong [10]. However, we
> believe that constraining potential memory safety issues to small unsafe
> blocks provides a significant advantage over writing in C, where the
> entire program text is to be considered one big unsafe block.
>
> With Rust now part of the kernel's core infrastructure [11], we would
> like to explore whether Rust is applicable for use in core MM data
> structures. We invite the community to this exploration and we would
> like to start the discussion. Specifically, we seek insights into:
>
>  - Which workloads set the performance bar?
>  - Would a type-safe API reduce consumer bugs, or would they just move
> elsewhere?
>  - Would rewriting core data structures introduce new, previously
> unseen, bugs**?
>
> *Under the Linux kernel CNA's CVE assignment policy, data corruption
> issues do not meet the cve.org definition of a vulnerability and are
> therefore not eligible for CVE assignment [3][4].
>
> **Our thought: The existing test suite covers years of real edge cases.
> A second implementation running against it is not just a rewrite, it is
> differential testing.

The downside to a second implementation is that it acts as a change
detector: If the tests run against both implementations (and we can't
drop the C implementation since Rust is not yet required to build the
kernel), any change to the C implementation must be accompanied by a
change to the Rust implementation. I'd be surprised if the C folks
would be pleased by this.

>
> Link: https://osskorea2025.sched.com/event/296sD/keynote-rust-in-the-linu=
x-kernel-why-greg-kroah-hartman-linux-kernel-maintainer-and-fellow-the-linu=
x-foundation [1]
> Link: https://lore.kernel.org/all/A5A976CB-DB57-4513-A700-656580488AB6@fl=
yingcircus.io [2]
> Link: https://www.cve.org/ResourcesSupport/Glossary#glossaryVulnerability=
 [3]
> Link: http://www.kroah.com/log/blog/2026/02/16/linux-cve-assignment-proce=
ss [4]
> Link: https://lore.kernel.org/all/d4a1cca4-96b8-4692-81f0-81c512f55ccf@me=
ta.com [5]
> Link: https://lore.kernel.org/all/5bee194c-9cd3-47e7-919b-9f352441f855@ke=
rnel.dk [6]
> Link: https://git.kernel.org/torvalds/c/de60fd8ddeda2 [7]
> Link: https://git.kernel.org/torvalds/c/a4864671ca0bf [8]
> Link: https://git.kernel.org/torvalds/c/6758c1128ceb4 [9]
> Link: https://lore.kernel.org/all/2025121614-CVE-2025-68260-558d@gregkh [=
10]
> Link: https://lore.kernel.org/all/20251213000042.23072-1-ojeda@kernel.org=
 [11]

