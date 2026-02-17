Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70B23E9A03B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 21:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02066B0088; Tue, 17 Feb 2026 16:51:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAFB76B0089; Tue, 17 Feb 2026 16:51:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A876A6B008A; Tue, 17 Feb 2026 16:51:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93B1E6B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:51:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 11D471A0302
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:51:16 +0000 (UTC)
X-FDA: 84455294952.21.1333B28
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2274780009
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:51:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="s/L+3PSe";
	spf=pass (imf02.hostedemail.com: domain of skhawaja@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771365074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CrejTwC6HRXWqV3w5dWaP4svnxkBSXMzKVd6LUpxqiI=;
	b=2mmHNdlqH0NdTNYlYwURAY3SIVrH57VjMxlk0ycPFtIRJXZgY6eCX2ZKb7WTukuGh3Cnm2
	5+MhqPIiNJo1JmVEFUiabfQ4LN1uM4QFsoQktvm8/uFy7q9r08Y1Ly+uqccAKGN6XzY069
	LjB/xHxUNqgjJWfjy8PxVvg/PSoT4DE=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="s/L+3PSe";
	spf=pass (imf02.hostedemail.com: domain of skhawaja@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771365074; a=rsa-sha256;
	cv=pass;
	b=Q9LNO4J83UJxNpJSk9Rt7iMKLR3W5XWDvnt4029oa9SIEams4J6w4wfRuAmorlrkDcVObq
	N/Aoc3coE4wl7hfJtZc+74EHlnZdEMu9Bizks7b604DFP6ChpVHIqvK+JHpjsgxz9yt1es
	8/eYDSMm7PEA05MwaPG+j0MXUkU3dHY=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5033b64256dso184691cf.0
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:51:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771365073; cv=none;
        d=google.com; s=arc-20240605;
        b=CpTH/l75/T+vW7z6nbNxVf0ZknnTD+KsID9A2AkV6w2Va/GAIPpNFs8NL3i8DF0hId
         Dm+0tGW5keDc4kgLHApe7ei30/L8X+v1fMGqllC60E0su4tPDYFTaYRX1aV1pGwBiJXL
         jItJC2amMSR0PAKODVszOQ9KIAI25OQF5o8TioOPf39otwyrzr8PJiUtaH3vvylyxf7H
         w8TzAMhX07XiUZBTiimS8Y2y53NyGmvvSzQq6y9JWx20oRBLOQOZSjsKQmKuVGhG3+pR
         xdTMP49rngNUbI/cOQOXEKVnkPQzQXvyHprPMRvcjz0HPOgnupweliWCyQGDiNX48Lpr
         685g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CrejTwC6HRXWqV3w5dWaP4svnxkBSXMzKVd6LUpxqiI=;
        fh=PRDwQlSZr5JR8NsD8m6C4br0LKaUa0RScBbMMkhQ9hg=;
        b=DclwUyj+G3jippbO1l+7ME8xwTtDZVgz6v19lSHD1fRQrBIDWyX4CUP4pWPNeK0qWJ
         DpFqlaoceXAm2YfcaNEpANt5KqHIUlH1UGgqe/BWG7WGwPIEfVLROX7q0o5oyU9UZUnD
         RvJFPdwpcOEyIWM+zFXZqg0hR/z+xWJWbgPic9K460NerA+viw7z8XkacDRLgo83t30O
         7SP+fheNCKlp98kK/liuGxz8tQNBYHzyvfChTnCcqoBRV8A+P2JNJddJQ2eehPeFvj8+
         HSMOLtawXRaP6ALjBzEI605tghLu7JGvPOwcWmIAa5WR73xYL6reNurJdB9O7tSMcsLJ
         f9Kw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771365073; x=1771969873; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CrejTwC6HRXWqV3w5dWaP4svnxkBSXMzKVd6LUpxqiI=;
        b=s/L+3PSeTA5Ma+sE64yQz+7iNqvhT1M14KKPVkrsWKG6+++8yxyBf0bSPoIx11MsUN
         hjknKLZ1Z1rirgHBprm7bi4rkKroXbCAPTy+jAi895m65ykkq+swLh1LJt5VMFfLIorC
         kzx//lyxu3IgMUM6NLnjC6H1nf8wZ4KQ3gmH+yZYRb5kgatiLyP/VYMCGQ/sboelJBmh
         w93ZL4AoOOsQZWrOjtFrIUXHb44a6eHonOex4w1vBvAhVQM2/9OX7c+TbC/a627vEKus
         XC49LraVkyxEyRexZFhCG2+8iQKVbuFPpaiygMA7sm9bU4iSS2k/6PfWRuUDyCtWgyaY
         /kTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771365073; x=1771969873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CrejTwC6HRXWqV3w5dWaP4svnxkBSXMzKVd6LUpxqiI=;
        b=txDsenCi0HtRwKJYID+Ajauc5GR0sqK27r3M5LteQkd6uK0T4gm/UFodVkhdAZicvk
         CKANK9KARcPeh3dy3tDGUodIv4CPpSeZRjmV97JY8f4ouAjfsA+R/dIpKWtsrkxGOsCL
         UK6yvhWZVXh8yWMvPyNzJi8FfFG0W1fjOjdg5SLGeuQ07wO81vGfvj4/T5ELGwPTo9KC
         vKE0NTahO4a8z3QoSSuQe/7n2qoa8OPznibJBcIP37QuxAozk+yLRQD3AkW2/AKi3D8S
         PpgHgs7mqfo//vjb7RSPj70GUmmcEFFJmmWIby0pWU2a4jPWJbvRUuPLQP6B9a/TgTrT
         nuFA==
X-Forwarded-Encrypted: i=1; AJvYcCUZ3wyLYPEn2dxREr0lFP73ROeUv8F7dGTeElXNus8pyvdoo+X7V8k2wC+Mfgi31qlkUfzJOpLD/g==@kvack.org
X-Gm-Message-State: AOJu0Yy15LyZWG7u+8ziI8fKCii/3H1Oa/JfzQeeX4ik78qnsTGDf60t
	KJ59EpV2OBrX3zEku3EX64BggzApvaU/7YMJGuuL+xiH56iTavOGfPKqQ+fC67NvB3YNJ0yjuh6
	oERw3PIb2Kw9NYkVRFECkaaLHPX9kaVhlrODkvtJj
X-Gm-Gg: AZuq6aJshBTkdFQUS8j33dSjEI5NJzk4XcE3g0j2J3avM/I5MZsX9b/yty9l+yk1urr
	x2BZiR557G8WuOYN45lrqeBhjrH4HxD0ktIjoyIxPfLLwh0VL4GRbTNsxHkxCeP2HnbVxQqMbZM
	Odpl2g9pvItbwxmku7yH9XAeZtQlwnD+JFLr3WwA4s0dKk/3YZg9uUS3QUysRxXzB6ISgGYQFRu
	RzM/SJglhnp6I/W3qhLbAZzcN5SMgSTPvxWKZixdUp87EKOGJ4FK36oSjJq8TW9ybc+8vpGuyvb
	uW95Z38Jv0mG3iHCkQQWT04AyY2XxHXL7Om9GQv+2Q==
X-Received: by 2002:ac8:5906:0:b0:4f3:5475:6b10 with SMTP id
 d75a77b69052e-506cdb209demr23925201cf.8.1771365072676; Tue, 17 Feb 2026
 13:51:12 -0800 (PST)
MIME-Version: 1.0
References: <20260216185946.1215770-1-pratyush@kernel.org>
In-Reply-To: <20260216185946.1215770-1-pratyush@kernel.org>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Tue, 17 Feb 2026 13:51:01 -0800
X-Gm-Features: AaiRm50qzGC3jHt4XCZiiavo0osc_e8UI64qPm53ZIqIovdo_Uo-mwrhf_TY6CI
Message-ID: <CAAywjhQ77zcA1wwf=i8vwG_FTtzJWc4d0MXz9aOuog7LgSSU6Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] mm: memfd_luo: preserve file seals
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6r9egdgb9soa96xhtcgraekypuhu6mqd
X-Rspam-User: 
X-Rspamd-Queue-Id: 2274780009
X-Rspamd-Server: rspam01
X-HE-Tag: 1771365073-908463
X-HE-Meta: U2FsdGVkX18lutOP720hiwyW/h0YPsXl7P8cf+aeJkAXA/SvAh8xhYX+0oHa8vHngxw8oTvPSa3cQ/MJoSXrERcTwLY8npRDbTXLea3Lib6C1EKa64DIWKOmM9fQMzn1WnBt1cB9l+gDUSm3w1VD9qzGdUCKhZUlet6LpMyotDAdT6OBtIe44B4/XD3cy4ThrBGe9jYpZdKT/wTdcqh6l7pywb+FrjfIfj0y+FHrK1OuM8VVmS1+1ahb+Gz69gUAM7V0oWeNcIHIuMC2tYmR9KpU7z0HLoCnItOvgdW5FdWg3Te7Hx8q4pm4mXXATIbT5LWBH9V9DOMB6U9l4okPYbcPqys+pCRR05Z5/YwnH1Ex1woYgDREzAX8dMxHM4U1+tIf3qX1a28W/lu2J6BKmEfQmNm2VYEKoNLd5kEJIgKcRU8pzvzrWKkzrYPBZhaGAefLmcbYET+MX3CmkGpUgqG+F+IksQyhtnBIjqHS0jyriacxNlPt7byrHpUQyxv2MW/bwltto0KeckMzcqd8DfNUryzOHz/XcVnCP0q771QTtgaDQvIoaMQNYjGdPkdCgEom1dqxs/wTM6vGGu6IpUh3KZTP95+NAz3Cl1WqoIJ4/t3BshCO9z5uXcADmcpxsyGf+xMWkomRACEp8jX16Z+GKGJyAVNRMsdUXCvtAwM91FTvHz69dUbvtfDTshThDM6Dg3hEl0s9zYHY01DAsOfkNL4qYw+PaTgFZjZanCID1D653IBJHxEWBH4hHKWcA2/QBt7GBvz1sVIs32xiJ5mxJJQM1PkIk0ONNjkQRAzgESJwwVeFmoOr8t/7RvCL8YItqsrIJCBNjXmNNzTe3PmxbXNFHeR2n8CrPIbav6/f5CXq9s7DBNA3KgM+Tjsi/IH8h7/RULKFE7AHg93GAWnNUy6CVn15oEtX25BNQxbF1v2giHFsdj9i1D0fs/G4zPASSWPxrEJ7AvAvUbx
 VwW0F9SS
 2cLTYxgiHPl8jutBWrCuSaTBUWyHl22rH8Xp3ZL//kRBAHqitqrkkD9lZYD0gYlatQ3XP0eRizrXAA4IO4N/15sbyWcWMuzzBhRIKD3kgFWNyxffCc4CxJYVqChe1il0ZyIG3XP8VDhOwuVveMa7wuCCJ+41GVMzAtp+khhgANB7vq5TKWvdqpqR2hfwx9I93Gd5oHuSwkfuieND0Kx32CW3pvt6CpECEVBF58/QQYy2ym8P5nebCc7OPGos53CRwA6oG09UXDPLUfOdPf9SxarhPkU9X2dPTqspNLMT1mcc6+k20BJQdFXcw0plYnWST/jladWJY3QWRAhI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 11:00=E2=80=AFAM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>
> Hi,
>
> This series adds support for preserving file seals when preserving a
> memfd using LUO. Patch 1 exports some memfd seal manipulation functions
> and patch 2 adds support for preserving them. Since it makes changes to
> the serialized data structure for memfd, it also bumps the version
> number.
>
> Changes in v2:
> - Define the set of seals supported by this version. Support for any
>   other seal would need a version bump. Make sure the memfd only has
>   this set of seals. Reject any that don't.
>
> - Make seals a u32 since uABI defined it as an int. Change the
>   __reserved into flags.
>
> Pratyush Yadav (Google) (2):
>   memfd: export memfd_{add,get}_seals()
>   mm: memfd_luo: preserve file seals
>
>  include/linux/kho/abi/memfd.h | 18 +++++++++++++++++-
>  include/linux/memfd.h         | 12 ++++++++++++
>  mm/memfd.c                    |  4 ++--
>  mm/memfd_luo.c                | 35 +++++++++++++++++++++++++++++++++--
>  4 files changed, 64 insertions(+), 5 deletions(-)
>
> --
> 2.53.0.335.g19a08e0c02-goog
>

Tested-by: Samiullah Khawaja <skhawaja@google.com>

Tested with IOMMU persistence patch series using iommufd_liveupdate test.

