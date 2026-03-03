Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5034EB3649
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 01:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE1A46B00D8; Mon,  2 Mar 2026 20:31:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAC256B00D9; Mon,  2 Mar 2026 20:31:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA1146B00DA; Mon,  2 Mar 2026 20:31:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAA9F6B00D8
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:31:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52040C1DA4
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:31:09 +0000 (UTC)
X-FDA: 84503023458.02.0672D44
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 45B284000C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:31:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fOJa286C;
	spf=pass (imf01.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772501467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sL3AUiITIoI8ls4IgZS8KlW243ZkuIpj6RQqzirDENg=;
	b=sH6IGCBjFs52RMWdLFOk2LJZuAyu8+sZ7hkoBd52inYJ68hh4lArf19C3QFfkFlAdHHQ9z
	v/EaKKgX1R5b31EAyTBf1xOHhzrkFpfV+Q8lpbHolY7gYdaVlb1gQToSYbfhrZbDmhENvx
	YeW5Qjln4qtle0hxGNXR7ed0fP0yTac=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fOJa286C;
	spf=pass (imf01.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772501467; a=rsa-sha256;
	cv=pass;
	b=TyXlbE1M34RbQb1Dzud9cVfdQS3wyOBip/teLyDY5wMKrhHFu5jw71laedyz5+/6DcPWmp
	6BZC4l+5yccR2XnFEVIeh1Xbf/CPZI8iMR9ZsagqqaK1fuBuwqSmf7Q/tJvURtMUUjhZBw
	kt0ytsEoeDCKsqL9ijLoiUYGd1WMqYc=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-126ea4e9697so2447c88.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 17:31:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772501466; cv=none;
        d=google.com; s=arc-20240605;
        b=Zb/MwLaaHDOetXhul5XPDDTM0SkbQ7ipXwoYV0AnTTBP+D2BZ2jjnCtLl+Jg4AboI/
         kinhVyngg2MZRIla968PYHUeZcuTM+IrDgdTA1U42QlNsENYEiucTfYmveT6lDm+zSX+
         wTbLO3zAKQ3t2TzyY0pynvMydRa5BaSWDyh5ZU60YPv9OOtj6TfBRGaqb/3Vvrl31KDJ
         8YpaqHcGBvINwFlMzGInxK8gk66ROWAxiLW1wVcBbNzTK/mNn2uGOc9TT9DMfv5R8/m0
         hARMvmICA3IBTxRy7mjSHA/FN06qzmTuvK2tNVfc7p0vVpXZz/0AVd1GxcRTFqiMxGYu
         2B/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sL3AUiITIoI8ls4IgZS8KlW243ZkuIpj6RQqzirDENg=;
        fh=Xou7I69PwnigUFZ7RFv0SUERM/kMDdC3IIYGi5zSy5s=;
        b=Ox9ca9p8bus+NhdEiHJpX72JmY9bg7N+tR5tst1ao95GpkqJh8hHn0zJmOvd+OiGKa
         vCWhP3hJUl7lULvvgwa0+qAJi5bjsp6c6B4jBBfuQSY/r3th8wHvnx73m8jfYrpaNx+D
         gQHfS1kmDYoOdedTDJlX40tFdFztvxp74K82UvBdvrEVtk9puZBfNaRLSQ84D2H+z8ST
         KoSgNIdXUeTq180+9ISwPwI6hQrvbBShCuIw5gEso/MZjvuacU5R2GpF2wWjCdTOmux9
         2+bNt3gq/S60ynm37yH22Jm7TFC7dgeVM2vcyqaAsknRCtHPt6uBNA6LJZeNwctBTW5u
         gzaQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772501466; x=1773106266; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sL3AUiITIoI8ls4IgZS8KlW243ZkuIpj6RQqzirDENg=;
        b=fOJa286CO41/BVagZETE5WX0tQ7dfQ0WvyR7CMEZuHKC1QLUfwv97vavBtHVtdYl+7
         evCCrwVH6NdasBZPa9gnEnIepMVt0/JNV3S9XFmPojTZ5+zzzYrB+GD/5NhurKPcmaZl
         m+kMRkjnWn9DvoxXFIG44Oj9ZRPK2kX16IGhI2S+McPMuvNEk9aSpLp7ZmHalqd2mybM
         G51EUHqIUvoC+WzfCrETSRMIvGQSLXSSCdVF/5J+YOgNkNGamCWRWDBj9IM3Jny3yEdE
         DTK/lJhKhAeY5z0nBpjIf144uCDpjPBeaEWHrshB9OyfphgiT5JG4qjFQ5Q0AiyjwnA1
         1AlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772501466; x=1773106266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sL3AUiITIoI8ls4IgZS8KlW243ZkuIpj6RQqzirDENg=;
        b=m0IXiqqRFN/tLXdWZ+YUWaeMTldMcQVDZ03a0wzFS148PtCx+ntOWzfetBTsbMcY2N
         C5S9lkfNcPfHbphvGxUfdOmqcYDjfey9UqXd230Xf5kijpXkKaW5fh9Jt5IcqVh+pRWI
         SNQIJh0x4zI2ZnSUWYqZWPzKf+Ly+I0Gh+vXKAgqsuKKnxQa8JzObHptRYu4f/7TSBfs
         GwyBzcxU+NGSV/swpLaeOfTA2ZReysU0nw3ex1Yk1KUKDR40BURjoEY25h4havezUS2C
         RUBktlg/cgPlZ+2/ak4u2qg6mMw2qj4+NdkJ/cmUF7c99pCujLcemBX10msETrcA1L8c
         MCBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUXAShmmm8diUJMm1b+/182IwjXsRvWr/OlqFb/X9LmQKFWpVrbSaSz+UFf3DKxhcqdmUI9KE5Fg==@kvack.org
X-Gm-Message-State: AOJu0Yw52cMsH3qL6nfcm1r9VFxFrwuT6CgE9gO35uv6bj2oTiUyO9i6
	qYYQW81p7sN2wQparAg3yAf3Gue9UDFrGVkJWMd+HUTj1ymjgEAQT1rzHiYgnEgNcU7DbiBW3mW
	irLaAOXPRdnn4WOgPlqzGddKQ6MUxT98S+JXxXq+C
X-Gm-Gg: ATEYQzzOXKaQvZEONl2p8WSj+8UTN+uYAvqDvrPawTJ7ce2lJdN3PVfX5MdPmUcUzmg
	n2O8bX4DNDEbMuaWsFlXULdI6d8EfXTnTYAk7DySk4kFCzGdmTrp0EgpaGSVsNHDijd5aCC4nNH
	pHaj8214tmXwKy0YJ0hjCX3TOW2kT4DLljQRw5tH+XJlfqFqcFZETlnmvVznErksGdl1o/C8aPb
	18fHsJY4hy8SMSuuY6d6N+QKKac1nUGiie2VZ21O5EOmEGuV9QEvi3jQ+nYJGC/u5W5503X464+
	+LCPeABI
X-Received: by 2002:a05:7022:4382:b0:120:5719:1857 with SMTP id
 a92af1059eb24-12796e465ffmr492999c88.21.1772501465278; Mon, 02 Mar 2026
 17:31:05 -0800 (PST)
MIME-Version: 1.0
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
 <aaBsrrmV25FTIkVX@casper.infradead.org>
In-Reply-To: <aaBsrrmV25FTIkVX@casper.infradead.org>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Mon, 2 Mar 2026 17:30:28 -0800
X-Gm-Features: AaiRm53ieRYchZixmEDMe8vzj5Fq7v4NWZS69hqnwQiMu4A-a8w63-VJjMWgCZE
Message-ID: <CAJHvVcioDfCxGRszaTOJST8ADszkB62N0WzzY_JQHp0t2bawsw@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improving MGLRU
To: Matthew Wilcox <willy@infradead.org>
Cc: Kairui Song <ryncsn@gmail.com>, lsf-pc@lists.linux-foundation.org, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 45B284000C
X-Rspamd-Server: rspam07
X-Stat-Signature: poi1o7qymce7fu7zamaz93uigd9s9i6f
X-Rspam-User: 
X-HE-Tag: 1772501467-154699
X-HE-Meta: U2FsdGVkX19kcdcishvVgfItJbT7mFSeXDrrRnIVyzU/Eyz23tw5jAWCP4l0y8YZ+BNVFBL2tqty1hPl2VO9o9YQHlv13uBTlkb0Ny3cre/PLC21LR4OHbOXa998DaAPuROUAjmdf9/TeEmtiP4qQFlHxQBWx7mH35RRfRwTp1/Vby68X8LYmyDfw6Eq7XKI42PzH12jIwxMv1THmOLWh40tVVAC69M5IBj4uDcmzELh4MiZGHFC9ezUk8Tb+l0LyRzNuvL0uaEFtgP+mfE01jvsxYbzSHR2VuOcioZReSbsdOGfXpuUeCeiR5E8daZ9I2MwuHTQTL0vf9vMHoCfM7cBcdtU3lRHCVEiljrXYqPIr8O8eGZJzzPFQ8TkwHV1vxNhrChS3753U3z/jEoA/BRa4bdlnzDRQrP393GUTNfRammAnm3KiyrzzA2KJcB+xn1cyzrBR2HtNNDhcOSmB3o3xcTqH9ezk7NH0eqHeplWf6XEjPXmy75s3xSPXhBAMeTpMGFy4+TFxnxATaYfnbfWhW4DXc67BIGtfTrvelVm7d+zoA7gJpx0BXdXLNQmvXdqqnYilCGm+0UVNC9C/5Ga0oJbRuk8uEqWhZNF+KVRSEyh/ISV+L7qTeQGKObUo6nw55pLhW5HTYUhqcEbqtx7SiJI+SHn9aF4Z+EeoqshS/B/Dc7BETqHJD4SWElH0Ky7sjqyBfBN9jGvAlRhBUZ2AMxUOmy4I6zmgg5/PuECUVkV+sGCm5CU44B7X9/yQXq0MUbt22Wg7v4Kd0mG4ZRw90ToYilcx3oXHuZQ3a6IGArdn6jSW3/nxe8I9AxbbWz1GgYa1+0JowCy7Rwa6mhE860IDoCAjwo3TrRXq4VWKOEM+QcrzSxlSkbtIE+d0n4UlozNgs2Jo1JxYp8zcJ9OHTcHmteK1vwG6fRjdWP8ue+oiHuEfQ+MbVo7vqjlFQHuQXauUdpw7KR/unl
 MZdMJPHP
 TGqQU+D9uX9WVUoy6M4oXBF7VqIyBLRH6p8YbkcgHPUwQWSJ5k+sVmQUAOtZqwmp37awXnt1Xo53QTLVBcJDWCbkDZ3dfjlUWtA47gcHpTLPNfgcHlP/32g3LAdsSOyiqJS6bZOP3ttW3FsFkuHi0F5p8Ty4W844WJ1aLZjP1ijUsGPk4eMU0lhSXfPnNxdO6pNHM8GlGS6w7Je0XKH8t4FX2f+P4TZLNkVEEsg72x4Wf6cyNJV3MOCVsr46Nx0O5gs31LwhP7YVeoUtBkSbnM3SmX7KsO//9O95B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 7:54=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Fri, Feb 20, 2026 at 01:25:33AM +0800, Kairui Song wrote:
> > MGLRU has been introduced in the mainline for years, but we still have =
two LRUs
> > today. There are many reasons MGLRU is still not the only LRU implement=
ation in
> > the kernel.
>
> To my mind, the biggest problem with MGLRU is that Google dumped it on us
> and ran away.  Commit 44958000bada claimed that it was now maintained and
> added three people as maintainers.  In the six months since that commit,
> none of those three people have any commits in mm/!  This is a shameful
> state of affairs.
>
> I say rip it out.

I acknowledge this is a big problem. We have let the community down
here, and we plan to correct this starting in April, e.g. by working
together with Kairui and others to address outstanding issues.

As part of qualifying MGLRU in our own production environment we've
been debugging and developing expertise on a variety of kernel
versions up to 6.18. Priority has been given to this qualification,
and did not offer enough attention to upstream engagement. We plan to
post any fixes / improvements discovered during this process to the
mailing list.

