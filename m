Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04F0B10A88EC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 17:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 703306B0005; Thu, 26 Mar 2026 13:31:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DAD56B008C; Thu, 26 Mar 2026 13:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F1B66B0092; Thu, 26 Mar 2026 13:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 519A56B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:31:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 303251A0C72
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:31:35 +0000 (UTC)
X-FDA: 84588906150.05.E274A58
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2EF5340009
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:31:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fdenlB1a;
	spf=pass (imf04.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774546293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ht1ydNu1umiMsWIVEKZmUkwLuvps5HNVkVlm/tB0atg=;
	b=AnPqxxgZPVvoLoJGpVrji+yeSRxwi4+lYz3KUMGVFJygR5jsP5275I/R2t7beVAxOOvs3w
	HxwZx7WIc6c6dcP6roJtFs7x0u7ZTMO1CLUCZVmbgeU1zBjqDLmVTr01d704AjwDIwfz6x
	vx4vy1w3kHJyulViryWzu7tarVM+fH8=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fdenlB1a;
	spf=pass (imf04.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774546293; a=rsa-sha256;
	cv=pass;
	b=tDbLxHR5toERg+9Hh2sWCQzWote81havOFmP/fweIl6e9izuSWhTEZFQmfqCcqFg82IYU0
	FF3SbJaTjQQjuAnOn5woADoglL39uXAws/aoSdHSypMgtoMtzr9aoMed9mxRz/W0lJKY29
	XMHjhTCknCXMw2tyzK1r2nj3EhAyoHw=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-124a7216c9cso85181c88.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:31:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774546292; cv=none;
        d=google.com; s=arc-20240605;
        b=EdG+g8dw1KdZY6ZPhRNH7RnaxWHr1x948OmOtb2tgokmZsyqrEKxwNhXbo4AWXxqoC
         nIaZn07+FKL/kYja0pyp+heGHzKnVJ755EthWygaliRkxSeYUahNtQB181sZ9gGjNYLy
         5w81lOIej+e2bncSlKmmZsVPFA+0wu3pJJMy+yCkvCCQokaBjumqj+NmZEk4ipQb0NJN
         64GITC4CEjuIb7dKd+uv0KLUoVM24kftxjrU0QULocL1jNoe2leclNtVXl1t7WTPEf7o
         ATCgGC+1Vz5oTLHWBd1bFRGI7sC7v6smsG3JMWdQGLg9n3P0j1JkIH+ZrfjCKdMoqupl
         1igQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ht1ydNu1umiMsWIVEKZmUkwLuvps5HNVkVlm/tB0atg=;
        fh=tNsy+cjIz6rLPN2XmtZIXUegYJxuPCjPh45U4MQHGqA=;
        b=VxQq3PtuXb/sKWehHSLeXbNParneNZUHos/MetDLg/IKMNMh8Dwsi7s2FogwP/8CiU
         7T4A4vDrQyRXuyLtjqyaekfRtbjBgHtBC8Q57oiUcD1TMObfQA7tEvZJx9c5oVL7shiY
         E37uHfvIX4abqJfE80XKGc20cBs/guEw1D2nGVbQZnptSgIN8d2X9u+G1N/ylw2z3kSN
         k34GpwOF+Ipa3mitCYRXKEhPGacU/GCgbWHB66de0hIezpY+xbt/RlRudIH0Uwen5qmJ
         +ZIeeK9LdPi5xkQBHJhEaqyehi5Vc2fJCBmoP1j8m+1F85Yc26Ixl4n+L4eipFf9INic
         45CA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774546292; x=1775151092; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ht1ydNu1umiMsWIVEKZmUkwLuvps5HNVkVlm/tB0atg=;
        b=fdenlB1aorKuV1+BXmtslJDTbBB+yb5Ho4vSHK80E+31//Ow8QbFEhJYJ3Qxs8g5rV
         UwT9yxStvRmtYN2k1rC440nqdnPtbIroiUcnRgD5QNrU6rCXE+stTNRHB6upZl9067b0
         p8n176rsmZ+h1qKLueEegUvnMq5RFLktwW2yPzxh+bZpdqexCHsnz+RDRVt5gwWVqafd
         hYbh7f8EgZyutek/IAUA6g2T5khHykbVmNCLMi/uZwiKJsIf0psjP/oo5pbzcvZgzjmO
         h/W/AnMQkT84NTxbhw5GKEn3OmfqIXEa2tUpfAAxuK+YfWAS3lLVyGGAHPCJwKjmIVdS
         NHJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774546292; x=1775151092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ht1ydNu1umiMsWIVEKZmUkwLuvps5HNVkVlm/tB0atg=;
        b=m0C7i+6+UOK3gT2n2ttmWtjxI2KpD9TmY2rBgijhUvbdO1IGfryfqQmbobSIiDa6xn
         rNhpNAJyc5iSCNrA2GnDNy1NSzbdLP+ZFCUnGZ9cqy7zF/eZyq4i1P1doKPhlZLsl0Fw
         jqhu3P9OnHKwvCja9ilTeiJ2pbdDMZXuXQ3UsY7oksLZ0ngQQYahxeLfAOGwt61vLPsp
         nAczinsNPmWxZLWOQltUcZ5Bu0UAg0BKJZwMU8+lNHRLSfNUOiRBzswDgL+ipFR+v4SW
         Mv6TY6qPtTPy67XzoOIyCHBuj/DhqhN634VwVCy+GrOuhM4M2qcuXzZj/eZF547ozvwK
         JfeA==
X-Forwarded-Encrypted: i=1; AJvYcCWztuYVcASMNYpxYIpxL4eHY4fq8hEXdGyPpeElDjBJydyGMhNUtsN8mV9wvTVXBliKOi9O37WkuQ==@kvack.org
X-Gm-Message-State: AOJu0YzNFrFbtNq1M/DWdkDdEvB161N8ISkJSkutmA/4iclYj/eyWX/L
	xSdV18mK1FEAf9ydhQctLAcfLYZPXvT8qxqsqfgXwl6cKWoahGsOgjFNQWe70TToJk4TZBgV1CK
	Wkup+krsiz16h8BWeD8XGmEkZ62AfKvo=
X-Gm-Gg: ATEYQzxj5kLZxnxH9OimwUg/gi8lJAVwPpKgxmwglP4PNUuhKo21UswEJQXWB6OAvmG
	b2W93RiD/POGM83aHkq+7whfg4N6OWHKrOsLA19kEyzihH8givePMvL5HEgAdBFifG1fMSX+xAD
	Ty72zfDQryQ3M0AYt6QQzqoXShCUKaseBmqzotLS6ynnOFdkuU7nJOvW0UH/dHliqcjiHbIwkGD
	aANqfm/IFT6WuSCrUcq0KpDUchHIGk5CetrH4DqnwmhL7Z+R1NNBCtpNwKcwZEK9zCCGfnmRGBg
	MnVjDOaJzdo9DehY3ZWP2olScH8MXtt5vx8OPjKauGpjZP9H9wSNV9v2ROyLz6WLVXkBe6s5k4r
	C7kx/lSYhLIrEcaomcMM8TqQ=
X-Received: by 2002:a05:7300:cd8a:b0:2c0:fec3:fd2b with SMTP id
 5a478bee46e88-2c15d3eebdemr2110432eec.5.1774546291859; Thu, 26 Mar 2026
 10:31:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260322192159.88138-1-ojeda@kernel.org> <20260323000327.111235-1-ojeda@kernel.org>
 <acEP7tl8pqFA3tK8@shell.armlinux.org.uk> <acUGAsjYvNvTEO92@google.com>
 <CANiq72mzPpkELXis1CiSbKUmBXNQYMiMmjj-7-sYiLh4T_JSOQ@mail.gmail.com> <9cf5a94c-0f37-446c-b63d-ddac5674d220@gmail.com>
In-Reply-To: <9cf5a94c-0f37-446c-b63d-ddac5674d220@gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 26 Mar 2026 18:31:18 +0100
X-Gm-Features: AQROBzAY2TUlph37K4tdyrXW3PnWDmlLF1E76Ca3evvsqWc92x8ByVyN4OKTlu0
Message-ID: <CANiq72=fm7FnfM2iqOLvsgxxx7X4LBkr7XU8=LWYqSzQ7zjJ2A@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
To: Christian Schrefl <chrisi.schrefl@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Jamie Cunliffe <Jamie.Cunliffe@arm.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, "Russell King (Oracle)" <linux@armlinux.org.uk>, 
	Miguel Ojeda <ojeda@kernel.org>, a.hindborg@kernel.org, acourbot@nvidia.com, 
	akpm@linux-foundation.org, anton.ivanov@cambridgegreys.com, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, dakr@kernel.org, 
	david@davidgow.net, gary@garyguo.net, johannes@sipsolutions.net, 
	justinstitt@google.com, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-um@lists.infradead.org, llvm@lists.linux.dev, 
	lossin@kernel.org, mark.rutland@arm.com, mmaurer@google.com, morbo@google.com, 
	nathan@kernel.org, nick.desaulniers+lkml@gmail.com, nicolas.schier@linux.dev, 
	nsc@kernel.org, peterz@infradead.org, richard@nod.at, 
	rust-for-linux@vger.kernel.org, tmgross@umich.edu, urezki@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 2EF5340009
X-Stat-Signature: naj6qg5e5qhmwzstqkdkft7g9jm6jq64
X-Rspamd-Server: rspam06
X-HE-Tag: 1774546292-994711
X-HE-Meta: U2FsdGVkX1+xH9mVRwVfOrUuzvygbTzB2EqN3tZvpJmpBqUcCXtp0iLyn5P3Th1bhB1EQOOY3PwYI3xQK0VDyVleKuprWQKtlXMlxpypzO0gntRjBFWkJeEu7Mi5P4sngCqHG8PMJdjqfFRSxsT0EzLy6pmnl+OsyW1Mz/YQXthgfKXXOEGAawX7w/HbS9jtrNPPQwwZTYYkAE6mGEo0coOalkYR7jaw1xuyAID5CaSNoVgAb+UvDdIvela7DbEon6lNu+MwWAa7D5Cl3/kjkuR9o3RjRPrMVKUrydAeZat1PBIr0WA4zId85UT/rR5GykLPRA96RIK52dzRVMQFv1GooftrYJuCO9O5Zw9lPe/5Ihrscp2+SCAWv3Vq89sq/s2Uco9iLvGK3K7BBm9S6NOVYeXm7eyEgWz1aEZsHJcYjsUVr34XfzosCauIr6Ok8hbEk0gziLrV9l7U17jacBi0Qm1YGVyQ6R4zRZtQfmKq4xsVMZqLzJmS1NJ2EU7lkNxaqv4S+6diRQsv14C2J6/fRdIPmkb3xwMuCxiO6B7xIhWjJ9yrYu3p8kzpvEylcSLqlyLocdt/97Xn8uEXvimNZTOybUquR3hTswWgZ9CujZCq7GMn8VxlVVXyUnTPJGyzlCZnJeyEC0KKMmeVz+QRImXWXhP19Fd7wC2E/7JnboQ/ehQzAUExfZf+SVBhxaOCG/TTV5zPIFZN6TrgflsLG+iX3NGdeVdlEs7ypn6HCvh8+8l2knPjkaQ6K6Kfu+jWzJyIwPppdNOZwOJxRocUa3Qq7lHSZEHpi/2xTfoDC+PArC6img1wReN4LwrT4v4Ru6hoW6LIugS4IBWGWqsD3n9a9DuLR+DdN8zN+9Mr/Tuf7JsSx9MWi0rXwawXnKdRUrOrf7OezLSKNpaCF/ioRIjpbsSb9WrAX3QzPqGIqC05KHefeQvxWx5+0/kfYa7VUmLjJinK4bD1CHC
 GbQaYb75
 GqPSP+nP7fE+nWhbfZfDcAql8Y4QZZ9rdWLwAvgMU2mcxFmnnjPn2EianQSwNUmHkNXun7+IH+jPLIrqKXGUAJ2Y9nxzUNPFKqVyyH58LFwxPkbcj0VyjSOq/2SOD/o8105BoE08VF+SUEm5voaAZrCH2IgXB9of2g0rjHol3vpS5OQjG3WoPp7Gi+SFOJ1w44QrX3AxQT6IyzZvZTgYE8Ke0Yr8d8DXjDeIB7I09BIEg1ZnOd8hRWzTdHH4ugOz/zK226OUBv7fOeYYH3p9we/5qSf5zIm3JHRjOMuf65PUU2/+6M+CGhYic3/daWl6v0nFpi6wMCZrenUE0nVn7EbUxkOIZZ0A23fFRSOLLjeWO0uARQrIZmcsRGRsemb8aVA+AAe72CZxrh3Av1R5Oo2eOhbchCzYbTj0/5415akMHaAY2IRuCGGu4DKnRHRvWiBPLgGmRaj7/kuZbG1mPeCUW1di/UlBAB33se78ssMNj1fP4VKwXUIBzBqUBKvTMRJGQ/1KCKuA6H5COS8uhYCNO1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 3:31=E2=80=AFPM Christian Schrefl
<chrisi.schrefl@gmail.com> wrote:
>
> It should probably be fine to use armv7a-none-eabi. I've mostly used
> arm-unknown-linux-gnueabi since I though it needed to match the
> bindgen-target (which is -linux-gnu for all architectures) and
> because from what I understand clang also uses arm-linux-gnueabi [1].
> Also when I selected the target I thought that we would also support
> armv6, but since I had no v6 hardware to test on I disabled it.

I see, thanks for the quick reply!

My current thinking is to enable this only for x86_64 and arm64, so if
you/arm decide to switch the target (and/or enable this experimental
feature), then that can be done without a rush, independently.

(Please take a look at Russell's reply as well about the short enums thing.=
)

Cheers,
Miguel

