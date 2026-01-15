Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D43FED4116C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 11:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A0BA6B008C; Thu, 15 Jan 2026 06:01:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2617F6B0093; Thu, 15 Jan 2026 06:01:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8B06B0095; Thu, 15 Jan 2026 06:01:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E15F06B008C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 06:01:46 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C9271602D5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:01:46 +0000 (UTC)
X-FDA: 84333907812.29.D15697E
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	by imf16.hostedemail.com (Postfix) with ESMTP id ECBDA18000A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:01:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A3XhpCyw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768474904; a=rsa-sha256;
	cv=none;
	b=opGzf8qn//UrrLSbpnGGDtsMOsEKYq/Vo12T7ovPp4m3kwQnn90GuJf0oc8yokxUzjHt2a
	ZNsXUeLl6IYNqMrIQm42aMr3xQr+rj2RmwV1+IehOlZY+NxfHMqtQ9v5JOBlgV38OJNXPe
	rBrF/pXVpYHAmUqQRNp8xA3eqLagWeY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A3XhpCyw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768474904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jLRjre9Gg4eyNJ2o86evdvpIpxkESL1mM8ZvZNnSRUo=;
	b=6woDBny6Mt7oZPBYzOCEMwyAc0MXxQWERv6QUl8SkF7fDXJyceaCvtdPPgcuWVbNcYb+DI
	Gw/Va6RYbv4G9GfcZPNdXlZWIwkC4/D3lrseuYuuFE0OcgL5QBkr0n+t+hGA9VdTUXKxLn
	dDuktNs5nPg2u7y9+NwK3zHLCsqLoaw=
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-47edd9024b1so4535155e9.3
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768474902; x=1769079702; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jLRjre9Gg4eyNJ2o86evdvpIpxkESL1mM8ZvZNnSRUo=;
        b=A3XhpCywNleijY34abtmX3ASTQ3S2odhg1DJLFG8GRYzCwqrlE3vpt+OgRruUzTLQE
         VCtnw7da0Wg9ia9L9ipLgPgWAIBK2Sx5gTpKLaKeTe5eoPLxBhlzmKvQJfM85V0ZVCZJ
         N5ilJ7PJ2VNf+mi6GfOv6G8iQXpM1hY8jgzQ01fForfgWduyXjTq8JDzjdVwMtNE7Fyf
         5xY5okLOroyH76kdmWLTPg3yuNRAdKZk1wqGjZbAN4yoF7YAa/26o7eJQ9r+J0UngX+d
         9ZDdP3LD+o69qvW6rELJlcRTdiX9lghWVXWSPKrlM3K45+nrTcV9BjdjVbm1WG5EAy4i
         kqcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768474902; x=1769079702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jLRjre9Gg4eyNJ2o86evdvpIpxkESL1mM8ZvZNnSRUo=;
        b=c9BcUMMkaxU+cpM7NbV55QZ2BFVuBAygaWjk122w5kSZHcCS+yf3ij1mLh5nYeCefg
         sKHVNp1IwvJVbPPVUhSWSUYT0OGh9T2M7+Usu7ZvrMQEUCC5LsKMakbfCrecbu2nIW+K
         f3ZWisjSfghg2JSjkoHsw7dSNiSbMBKUlGtoBfpb4UG4wb/bVP6k5l80kV378jsDzPuQ
         GvWI7Li/oxcH+vdiylnHaWRvetdNdqSQlYNjIyq2mnHksN6qiB8CopP5UaTQKGgyqEo7
         mKyuCGiD7NAUJluE6TmPJTAVUF0v7XhFT+fyyCHF5s7WwpedHQYCLX4UW/6Hplt5FQRu
         Rf0g==
X-Forwarded-Encrypted: i=1; AJvYcCXz2cS/43+E6SGLJuXfaZIiSJQ7eHvzNw7WnMiRG9sUDFnC6L4iMTkpFVW4gIZRzw+Dy9c6yoDF6Q==@kvack.org
X-Gm-Message-State: AOJu0Ywxtoer/5tzvorN0mJ/PIwX2x3ok6gldxksrXopfr/vVm4XSyIT
	5lRb/TWORmhHHuRZmWFf2wZ7z1GlRIIx0t8L/y1n3ZWDTmRa6hj9Z9oF
X-Gm-Gg: AY/fxX6nKQkGmlQLTfv1IB2cWdPSRd2Qr8osf0FgOb1J9zD2kam18l2B6dKmwfGABgj
	ooUpG9YNkK2dDUHUab3YYFcMElJgKNrbFzQaTIp0UwIIJaWzBnmOUenIHoSgstAtwbD+DvUter1
	yV+aFi78evbOSjJdrJHxO+lIGR+F7NGfdXHEYabWz0KIVVGvLnF+n2BFEpPHPNWggvpgguGuFM7
	Uqk7aQyHRITab5MCHvu/i0MsRXzHtaod6Fs33/QqbYq9BWWrbKDB7eq9s+Frk4A4wYed895cTOr
	7fa6+p2NB2YxJVYDMHbWOFOJ7x91P0mP9eBc88J8IomeRTNGhj50W0sWl8Fsff2nulWEo8xdzkw
	bFX/WiHS5mOSLqlgkM7ur7sOuyYRqeTBAO154bH3BxqPUSM3GDbH+gYE3s4JZ2fEkdIkncIPgl6
	jAHfPxMNA=
X-Received: by 2002:a05:600c:a45:b0:477:a978:3a7b with SMTP id 5b1f17b1804b1-47ee33641ffmr63613455e9.22.1768474901385;
        Thu, 15 Jan 2026 03:01:41 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47f428afd9csm40912765e9.6.2026.01.15.03.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 03:01:40 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: zkabelac@redhat.com
Cc: adrelanos@whonix.org,
	arraybolt3@gmail.com,
	cryptsetup@lists.linux.dev,
	dm-devel@lists.linux.dev,
	gmazyland@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mpatocka@redhat.com
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is exhausted
Date: Thu, 15 Jan 2026 14:01:23 +0300
Message-ID: <20260115110136.276816-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <fc1d7900-3a5f-4b31-8aa3-8c8cd317d646@redhat.com>
References: <fc1d7900-3a5f-4b31-8aa3-8c8cd317d646@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ECBDA18000A
X-Stat-Signature: b3sy48yqkkordsikd6ynaxdrbpgd7nz7
X-Rspam-User: 
X-HE-Tag: 1768474903-77941
X-HE-Meta: U2FsdGVkX18V53mLK71SAkcWcnNfkTdxMdqrL9EXwHL7lD3z0HxFp0u3VgINxaAnvNWrZAGeyR2NnNxfVq8KHNFKfrWXXSe03ZoUw9i7nsL6Y86pGUU6m+5frxp/oykwNoOykbBJuMo/AtGG7g2uFpr2mfIvLnckr0wj6eN6xLkAfN9Dw6Bb1mV2vHKoYNKFCfYMISQWKwMbrDe+KlUklA/cNKH8ZKmhEYQu/fCK1z3uk1Jf2aRWkH1HBpE6Vz3ca7kjENWUNiF5/tIPutX/5j3iCSLWcKD6OHBbLMADjQw0CdPvNOVqeo/BlUyQPHE7HTqSrWEk/KdjTXHsk2GRD9/Dk/fS6oA9V2wmsBHnO+vAhSjy+ZMeZqbuN2IZsXfKoNq1802skWpSNIvePpDo2+aCTLvKuJ7UIe1uJN/4KQT/70l08NO5JrhdhdwidrdPL3yFlvJ0U1ZvRiTPITrzrjisyK/JOL83fBMu3GxCThKItNoeOcI7Y2muYG612A74CzV8xmS2E179KlD7IRb2PNc60DjSY8/U5Say9JF/Oe8wWkV6Q8gj7HOFoa51x6+yufihBZivCWY4+PndcFA9TXj9JCbRbOdlei9teRcaN1/WB68aaa2mH+IvgwmaoiE3jS2/aaTnCo+ybifVo8Nw5E2LQ168BXjAmT+nzWMI65vzt7hUuIXncnqAavtcV9Bi09USNILFKzA3ILZmyH4GtWtPxhz9nHK+neIzZp7+G7UWpbmtzcuohv5md9bN/w9zaJyLgHatikcldi4O7mvODTCGp3QSI+xPqehwzHbsJNajaw68MOmYr+9lWIK40iVj84na2yCj5zionG23ZSCvZT2UBCrCtHOnaxrz9qq8NTrn9LAMG4kjo/8607L+ljKnBJmi2j0ab4kao5S3vnQ38GhoYinOyyEo+KZB2Yy7um5VOcBYFp8YOB7KEqMPfFP5MsK9DwCybnQ0KPXOHmX
 JLHQKAHc
 eO9ko3o03v8jyid7Tcs+G8EaY2tHcvqOmGOISw3GAvZyPpfe2tUoQumkgfH41sGLAyG/Jv9nPRiLE7aJltjGkk+d9ATOR03tq0I0F201WPPYbC/kdlf1LiovpGq3couXGo42hmbp7gNkMvsnbEl3cEpBi6Op+sTZdzdLKxMe28Au++A+/62D9V4QNhygs2a3965ktE9dSIU1tcggAMQG2JJnvtzxN+NGjwXnDCgOE7BA7nfKbUXxlj3F0GebzYsOLkDxzYj79l60WW8wctEhwgSNKsyW6RY96hxi6SBNErLtPgAh6eQ+q6zCZQk2OjxtmZ6wGVfgLj7uQWVNi4Z7jBQ8KC1BEDURdhEkt9+uW3HBWI3eWm/Xr5siaJUSnLL/Vk6g1BivefZ5clUv/aYupRHHt3UHSAy90egDOlNP82MK/36+KIbAjTEMBFGzJtVxzPTEIgfkjTuMiKGihJfqRO2kDRDjX5sT3RqD6486dh7oRZTMI5gM6aldZOgMEqsujrdt5iAwyRHiWdXr4SPX5yw4LYEk/JV48qUPv7qAdjjgKVrU/O6jIA642Nw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zdenek Kabelac <zkabelac@redhat.com>:
> So I think you should also show whole device tree of your system and some more

Anyway, here is some more info about my system. Keep is mind that this is
*current* configuration. It has one important difference from previous
one: currently my dm-integrity is in non-journaled mode. Otherwise this configuration
is the same as previous one.

Here we go.

d-root@comp:~# cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 13 (trixie)"
NAME="Debian GNU/Linux"
VERSION_ID="13"
VERSION="13 (trixie)"
VERSION_CODENAME=trixie
DEBIAN_VERSION_FULL=13.1
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
d-root@comp:~# uname -a
Linux comp 6.12.48+deb13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.12.48-1 (2025-09-20) x86_64 GNU/Linux
d-root@comp:~# cat /proc/swaps
Filename                                Type            Size            Used            Priority
/dev/dm-0                               partition       396393016       83557452        -2
d-root@comp:~# free -h
               total        used        free      shared  buff/cache   available
Mem:            62Gi        44Gi       651Mi       2.7Gi        21Gi        18Gi
Swap:          378Gi        79Gi       298Gi
d-root@comp:~# ls -l /dev/mapper/swap
lrwxrwxrwx 1 root root 7 Dec 24 05:56 /dev/mapper/swap -> ../dm-0
d-root@comp:~# integritysetup status /dev/dm-0
/dev/dm-0 is active and is in use.
  type:    INTEGRITY
  tag size: 8
  integrity: xxhash64
  device:  /dev/nvme0n1p2
  sector size:  512 bytes
  interleave sectors: 32768
  size:    792786040 sectors
  mode:    read/write
  failures: 0
  journal: not active
d-root@comp:~# blkid
/dev/nvme0n1p1: LABEL="main-root" UUID="015793d4-ad51-4da7-844b-fcc3bcb13a0b" UUID_SUB="28e33bfa-c18e-45f7-8a65-7613553e5d84" BLOCK_SIZE="4096" TYPE="btrfs" PARTUUID="99349062-a789-4c8d-adad-0b7bf34f81ea"
/dev/nvme0n1p2: TYPE="DM_integrity" PARTLABEL="main-swap" PARTUUID="c4bbc73d-7909-42ea-8d96-eab82512cbe7"
/dev/nvme1n1p4: LABEL_FATBOOT="ESP" LABEL="ESP" UUID="ED4C-D5C6" BLOCK_SIZE="512" TYPE="vfat" PARTLABEL="esp" PARTUUID="10783aed-06b6-448e-b5ef-a6b8b79451ca"
/dev/nvme1n1p2: LABEL="alt" UUID="f37b8198-4593-4784-8c46-0e6cf5c3df5c" UUID_SUB="7af4c0f3-e38e-4337-bc39-808e603f343b" BLOCK_SIZE="4096" TYPE="btrfs" PARTLABEL="alt" PARTUUID="80c0642c-21a1-42eb-8fcd-66b8d8acf159"
/dev/nvme1n1p5: UUID="035420e4-c437-4d48-8ab5-01c785d03cbb" UUID_SUB="6dab00d8-3283-4828-99ce-4efd4f141f5c" BLOCK_SIZE="4096" TYPE="btrfs" PARTUUID="0481eb78-0846-4285-9e4c-33a6e883ce61"
/dev/nvme1n1p3: UUID="bd6cec59-9285-4ca4-afed-cf52b8c3237c" TYPE="swap" PARTLABEL="alt-swap" PARTUUID="10b075be-db5a-4aec-9ff1-1bac3db89fc7"
/dev/nvme1n1p1: LABEL="main-root" UUID="015793d4-ad51-4da7-844b-fcc3bcb13a0b" UUID_SUB="afe68734-6328-4b8d-8dbf-45f5be854530" BLOCK_SIZE="4096" TYPE="btrfs" PARTUUID="ab076d40-9562-4b7e-9880-eee4f4d57a02"
/dev/mapper/swap: UUID="75e65f8d-e4b2-4563-8dd8-9666cdd53c9c" TYPE="swap"
d-root@comp:~# lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
nvme0n1     259:0    0   3.7T  0 disk
├─nvme0n1p1 259:1    0   3.4T  0 part  /rbt
│                                      /mnt/btrfs
│                                      /
└─nvme0n1p2 259:2    0   384G  0 part
  └─swap    254:0    0   378G  0 crypt [SWAP]
nvme1n1     259:3    0   3.6T  0 disk
├─nvme1n1p1 259:4    0   3.5T  0 part
├─nvme1n1p2 259:5    0 123.6G  0 part  /srv
├─nvme1n1p3 259:6    0    32G  0 part
├─nvme1n1p4 259:7    0   953M  0 part  /boot/efi
└─nvme1n1p5 259:8    0    10G  0 part
d-root@comp:~# df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs         32G     0   32G   0% /dev
/dev/nvme0n1p1  3.5T  2.5T  887G  75% /
tmpfs            32G  3.3G   28G  11% /dev/shm
tmpfs            13G  2.0M   13G   1% /run
efivarfs        438K  270K  164K  63% /sys/firmware/efi/efivars
tmpfs           5.0M  8.0K  5.0M   1% /run/lock
tmpfs           300G  1.7G  299G   1% /tmp
tmpfs           1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
/dev/nvme0n1p1  3.5T  2.5T  887G  75% /mnt/btrfs
/dev/nvme0n1p1  3.5T  2.5T  887G  75% /rbt
tmpfs           6.3G  216K  6.3G   1% /run/user/1000
tmpfs           6.3G   40K  6.3G   1% /run/user/105
tmpfs           1.0M     0  1.0M   0% /run/credentials/getty@tty4.service
/dev/nvme1n1p4  952M   57M  895M   6% /boot/efi
/dev/nvme1n1p2  124G   54G   69G  45% /srv
overlay         3.5T  2.5T  887G  75% /var/lib/docker/overlay2/80f76802641489e2ff428f7244f21486959eec9a9bcffb077aae06be2deef391/merged
tmpfs           1.0M     0  1.0M   0% /run/credentials/getty@tty3.service
d-root@comp:~# uptime
 13:57:57 up 22 days,  8:02,  1 user,  load average: 12.16, 12.63, 10.15
d-root@comp:~# lspci -vvvvv
00:00.0 Host bridge: Intel Corporation Device a702 (rev 01)
        Subsystem: Dell Device 0c42
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        IOMMU group: 1

00:02.0 VGA compatible controller: Intel Corporation Raptor Lake-S UHD Graphics (rev 04) (prog-if 00 [VGA controller])
        Subsystem: Dell Device 0c42
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 232
        IOMMU group: 0
        Region 0: Memory at 604b000000 (64-bit, non-prefetchable) [size=16M]
        Region 2: Memory at 4000000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at 3000 [size=64]
        Expansion ROM at 000c0000 [virtual] [disabled] [size=128K]
        Capabilities: [40] Vendor Specific Information: Len=0c <?>
        Capabilities: [70] Express (v2) Root Complex Integrated Endpoint, IntMsgNum 0
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag- RBE+ FLReset+ TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- FLReset-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis- NROPrPrP- LTR-
                         10BitTagComp- 10BitTagReq- OBFF Not Supported, ExtFmt- EETLPPrefix-
                         EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
                         FRS-
                         AtomicOpsCap: 32bit- 64bit- 128bitCAS-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                         AtomicOpsCtl: ReqEn-
                         IDOReq- IDOCompl- LTR- EmergencyPowerReductionReq-
                         10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
        Capabilities: [ac] MSI: Enable+ Count=1/1 Maskable+ 64bit-
                Address: fee00018  Data: 0000
                Masking: 00000000  Pending: 00000000
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100 v1] Process Address Space ID (PASID)
                PASIDCap: Exec- Priv-, Max PASID Width: 14
                PASIDCtl: Enable- Exec- Priv-
        Capabilities: [200 v1] Address Translation Service (ATS)
                ATSCap: Invalidate Queue Depth: 00
                ATSCtl: Enable-, Smallest Translation Unit: 00
        Capabilities: [300 v1] Page Request Interface (PRI)
                PRICtl: Enable- Reset-
                PRISta: RF- UPRGI- Stopped+ PASID+
                Page Request Capacity: 00008000, Page Request Allocation: 00000000
        Capabilities: [320 v1] Single Root I/O Virtualization (SR-IOV)
                IOVCap: Migration- 10BitTagReq- IntMsgNum 0
                IOVCtl: Enable- Migration- Interrupt- MSE- ARIHierarchy- 10BitTagReq-
                IOVSta: Migration-
                Initial VFs: 7, Total VFs: 7, Number of VFs: 0, Function Dependency Link: 00
                VF offset: 1, stride: 1, Device ID: a788
                Supported Page Size: 00000553, System Page Size: 00000001
                Region 0: Memory at 0000004010000000 (64-bit, non-prefetchable)
                Region 2: Memory at 0000004020000000 (64-bit, prefetchable)
                VF Migration: offset: 00000000, BIR: 0
        Kernel driver in use: i915
        Kernel modules: i915, xe

00:04.0 Signal processing controller: Intel Corporation Raptor Lake Dynamic Platform and Thermal Framework Processor Participant (rev 01)
        Subsystem: Dell Device 0c42
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        IOMMU group: 2
        Region 0: Memory at 604c100000 (64-bit, non-prefetchable) [size=128K]
        Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>
        Kernel driver in use: proc_thermal_pci
        Kernel modules: processor_thermal_device_pci

00:06.0 PCI bridge: Intel Corporation Raptor Lake PCIe 4.0 Graphics Port (rev 01) (prog-if 00 [Normal decode])
        Subsystem: Dell Device 0c42
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin D routed to IRQ 122
        IOMMU group: 3
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: f000-0fff [disabled] [16-bit]
        Memory behind bridge: 92300000-923fffff [size=1M] [32-bit]
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff [disabled] [64-bit]
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- RBE+ TEE-IO-
                DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 256 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
                LnkCap: Port #5, Speed 16GT/s, Width x4, ASPM L1, Exit Latency L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes, LnkDisable- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 16GT/s, Width x4
                        TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
                        Slot #0, PowerLimit 75W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState+
                RootCap: CRSVisible-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range ABC, TimeoutDis+ NROPrPrP- LTR+
                         10BitTagComp+ 10BitTagReq+ OBFF Not Supported, ExtFmt- EETLPPrefix-
                         EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
                         FRS- LN System CLS Not Supported, TPHComp- ExtTPHComp- ARIFwd+
                         AtomicOpsCap: Routing+ 32bit+ 64bit+ 128bitCAS+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
                         AtomicOpsCtl: ReqEn+ EgressBlck+
                         IDOReq- IDOCompl- LTR+ EmergencyPowerReductionReq-
                         10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
                LnkCap2: Supported Link Speeds: 2.5-16GT/s, Crosslink- Retimer+ 2Retimers+ DRS-
                LnkCtl2: Target Link Speed: 16GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB preshoot
                LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete+ EqualizationPhase1+
                         EqualizationPhase2+ EqualizationPhase3+ LinkEqualizationRequest-
                         Retimer- 2Retimers- CrosslinkRes: unsupported
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee00258  Data: 0000
        Capabilities: [90] Subsystem: Dell Device 0c42
        Capabilities: [a0] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UESvrt: DLP+ SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr- CorrIntErr- HeaderOF-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+ CorrIntErr- HeaderOF-
                AERCap: First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 00000000 00000000 00000000 00000000
                RootCmd: CERptEn+ NFERptEn+ FERptEn+
                RootSta: CERcvd- MultCERcvd- UERcvd- MultUERcvd-
                         FirstFatal- NonFatalMsg- FatalMsg- IntMsgNum 0
                ErrorSrc: ERR_COR: 0100 ERR_FATAL/NONFATAL: 0000
        Capabilities: [220 v1] Access Control Services
                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
                ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
        Capabilities: [200 v1] L1 PM Substates
                L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
                          PortCommonModeRestoreTime=110us PortTPowerOnTime=500us
                L1SubCtl1: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1-
                           T_CommonMode=110us LTR1.2_Threshold=616448ns
                L1SubCtl2: T_PwrOn=500us
        Capabilities: [150 v1] Precision Time Measurement
                PTMCap: Requester- Responder+ Root+
                PTMClockGranularity: 4ns
                PTMControl: Enabled+ RootSelected+
                PTMEffectiveGranularity: Unknown
        Capabilities: [280 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
                VC1:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable- ID=1 ArbSelect=Fixed TC/VC=00
                        Status: NegoPending- InProgress-
        Capabilities: [a30 v1] Secondary PCI Express
                LnkCtl3: LnkEquIntrruptEn- PerformEqu-
                LaneErrStat: 0
        Capabilities: [a90 v1] Data Link Feature <?>
        Capabilities: [a9c v1] Physical Layer 16.0 GT/s <?>
        Capabilities: [edc v1] Lane Margining at the Receiver
                PortCap: Uses Driver-
                PortSta: MargReady+ MargSoftReady-
        Kernel driver in use: pcieport

00:08.0 System peripheral: Intel Corporation GNA Scoring Accelerator module (rev 01)
        Subsystem: Dell Device 0c42
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 255
        IOMMU group: 4
        Region 0: Memory at 604c161000 (64-bit, non-prefetchable) [disabled] [size=4K]
        Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Capabilities: [a0] Vendor Specific Information: Len=14 <?>
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [f0] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-

00:0a.0 Signal processing controller: Intel Corporation Raptor Lake Crashlog and Telemetry (rev 01)
        Subsystem: Dell Device 0c42
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        IOMMU group: 5
        Region 0: Memory at 604c140000 (64-bit, non-prefetchable) [size=32K]
        Capabilities: [70] Express (v2) Root Complex Integrated Endpoint, IntMsgNum 0
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag+ RBE- FLReset- TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis- NROPrPrP- LTR-
                         10BitTagComp- 10BitTagReq- OBFF Not Supported, ExtFmt- EETLPPrefix-
                         EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
                         FRS-
                         AtomicOpsCap: 32bit- 64bit- 128bitCAS-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                         AtomicOpsCtl: ReqEn-
                         IDOReq- IDOCompl- LTR- EmergencyPowerReductionReq-
                         10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
        Capabilities: [d0] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100 v1] Designated Vendor-Specific: Vendor=8086 ID=0002 Rev=1 Len=16 <?>
        Capabilities: [110 v1] Designated Vendor-Specific: Vendor=8086 ID=0003 Rev=1 Len=16 <?>
        Capabilities: [120 v1] Designated Vendor-Specific: Vendor=8086 ID=0004 Rev=1 Len=16 <?>
        Kernel driver in use: intel_vsec
        Kernel modules: intel_vsec

00:12.0 Serial controller: Intel Corporation Device 7a78 (rev 11) (prog-if 00 [8250])
        Subsystem: Dell Device 0c42
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 26
        IOMMU group: 6
        Region 0: Memory at 604c130000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] Vendor Specific Information: Len=14 <?>
        Kernel driver in use: intel_ish_ipc
        Kernel modules: intel_ish_ipc

00:14.0 USB controller: Intel Corporation Raptor Lake USB 3.2 Gen 2x2 (20 Gb/s) XHCI Host Controller (rev 11) (prog-if 30 [XHCI])
        Subsystem: Dell Device 0c42
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 200
        IOMMU group: 7
        Region 0: Memory at 604c120000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] MSI: Enable+ Count=8/8 Maskable- 64bit+
                Address: 00000000fee00d18  Data: 0000
        Capabilities: [90] Vendor Specific Information: Len=14 <?>
        Capabilities: [b0] Vendor Specific Information: Len=00 <?>
        Kernel driver in use: xhci_hcd
        Kernel modules: mei_me, xhci_pci

00:14.2 RAM memory: Intel Corporation Raptor Lake-S PCH Shared SRAM (rev 11)
        Subsystem: Dell Device 0c42
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        IOMMU group: 7
        Region 0: Memory at 604c158000 (64-bit, non-prefetchable) [disabled] [size=16K]
        Region 2: Memory at 604c160000 (64-bit, non-prefetchable) [disabled] [size=4K]
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-

00:14.3 Network controller: Intel Corporation Raptor Lake-S PCH CNVi WiFi (rev 11)
        Subsystem: Intel Corporation Device 4090
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        IOMMU group: 8
        Region 0: Memory at 604c154000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [c8] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, IntMsgNum 0
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag- RBE- FLReset+ TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+ FLReset-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
                DevCap2: Completion Timeout: Range B, TimeoutDis+ NROPrPrP- LTR+
                         10BitTagComp- 10BitTagReq- OBFF Via WAKE#, ExtFmt- EETLPPrefix-
                         EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
                         FRS-
                         AtomicOpsCap: 32bit- 64bit- 128bitCAS-
                DevCtl2: Completion Timeout: 16ms to 55ms, TimeoutDis-
                         AtomicOpsCtl: ReqEn-
                         IDOReq- IDOCompl- LTR+ EmergencyPowerReductionReq-
                         10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
        Capabilities: [80] MSI-X: Enable+ Count=16 Masked-
                Vector table: BAR=0 offset=00002000
                PBA: BAR=0 offset=00003000
        Capabilities: [100 v1] Latency Tolerance Reporting
                Max snoop latency: 0ns
                Max no snoop latency: 0ns
        Capabilities: [164 v1] Vendor Specific Information: ID=0010 Rev=0 Len=014 <?>
        Kernel driver in use: iwlwifi
        Kernel modules: iwlwifi

00:15.0 Serial bus controller: Intel Corporation Raptor Lake Serial IO I2C Host Controller #0 (rev 11)
        Subsystem: Dell Device 0c42
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 27
        IOMMU group: 9
        Region 0: Memory at 4017000000 (64-bit, non-prefetchable) [size=4K]
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D3 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] Vendor Specific Information: Len=14 <?>
        Kernel driver in use: intel-lpss
        Kernel modules: intel_lpss_pci

00:15.1 Serial bus controller: Intel Corporation Raptor Lake Serial IO I2C Host Controller #1 (rev 11)
        Subsystem: Dell Device 0c42
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 40
        IOMMU group: 9
        Region 0: Memory at 4017001000 (64-bit, non-prefetchable) [size=4K]
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D3 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] Vendor Specific Information: Len=14 <?>
        Kernel driver in use: intel-lpss
        Kernel modules: intel_lpss_pci

00:16.0 Communication controller: Intel Corporation Raptor Lake CSME HECI #1 (rev 11)
        Subsystem: Dell Device 0c42
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 130
        IOMMU group: 10
        Region 0: Memory at 604c15d000 (64-bit, non-prefetchable) [size=4K]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee00378  Data: 0000
        Capabilities: [a4] Vendor Specific Information: Len=14 <?>
        Kernel driver in use: mei_me
        Kernel modules: mei_me

00:1a.0 PCI bridge: Intel Corporation Raptor Lake PCI Express Root Port #25 (rev 11) (prog-if 00 [Normal decode])
        Subsystem: Dell Device 0c42
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 123
        IOMMU group: 11
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: f000-0fff [disabled] [16-bit]
        Memory behind bridge: 92200000-922fffff [size=1M] [32-bit]
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff [disabled] [64-bit]
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- RBE+ TEE-IO-
                DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 256 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
                LnkCap: Port #25, Speed 16GT/s, Width x4, ASPM L1, Exit Latency L1 <64us
                        ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes, LnkDisable- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 16GT/s, Width x4
                        TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
                        Slot #24, PowerLimit 25W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCap: CRSVisible-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range ABC, TimeoutDis+ NROPrPrP- LTR+
                         10BitTagComp- 10BitTagReq- OBFF Via WAKE#, ExtFmt+ EETLPPrefix+, MaxEETLPPrefixes 2
                         EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
                         FRS- LN System CLS Not Supported, TPHComp- ExtTPHComp- ARIFwd+
                         AtomicOpsCap: Routing- 32bit- 64bit- 128bitCAS-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd+
                         AtomicOpsCtl: ReqEn- EgressBlck-
                         IDOReq- IDOCompl- LTR+ EmergencyPowerReductionReq-
                         10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
                LnkCap2: Supported Link Speeds: 2.5-16GT/s, Crosslink- Retimer+ 2Retimers+ DRS-
                LnkCtl2: Target Link Speed: 16GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB preshoot
                LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete+ EqualizationPhase1+
                         EqualizationPhase2+ EqualizationPhase3+ LinkEqualizationRequest-
                         Retimer- 2Retimers- CrosslinkRes: unsupported
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee00278  Data: 0000
        Capabilities: [98] Subsystem: Dell Device 0c42
        Capabilities: [a0] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UESvrt: DLP+ SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr- CorrIntErr- HeaderOF-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+ CorrIntErr- HeaderOF-
                AERCap: First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 00000000 00000000 00000000 00000000
                RootCmd: CERptEn+ NFERptEn+ FERptEn+
                RootSta: CERcvd- MultCERcvd- UERcvd- MultUERcvd-
                         FirstFatal- NonFatalMsg- FatalMsg- IntMsgNum 0
                ErrorSrc: ERR_COR: 0000 ERR_FATAL/NONFATAL: 0000
        Capabilities: [220 v1] Access Control Services
                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
                ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
        Capabilities: [200 v1] L1 PM Substates
                L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
                          PortCommonModeRestoreTime=60us PortTPowerOnTime=42us
                L1SubCtl1: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+
                           T_CommonMode=60us LTR1.2_Threshold=366592ns
                L1SubCtl2: T_PwrOn=300us
        Capabilities: [150 v1] Precision Time Measurement
                PTMCap: Requester- Responder+ Root+
                PTMClockGranularity: 4ns
                PTMControl: Enabled+ RootSelected+
                PTMEffectiveGranularity: Unknown
        Capabilities: [a30 v1] Secondary PCI Express
                LnkCtl3: LnkEquIntrruptEn- PerformEqu-
                LaneErrStat: 0
        Capabilities: [a90 v1] Data Link Feature <?>
        Capabilities: [a9c v1] Physical Layer 16.0 GT/s <?>
        Capabilities: [edc v1] Lane Margining at the Receiver
                PortCap: Uses Driver-
                PortSta: MargReady+ MargSoftReady-
        Kernel driver in use: pcieport

00:1b.0 PCI bridge: Intel Corporation Raptor Lake PCI Express Root Port #17 (rev 11) (prog-if 00 [Normal decode])
        Subsystem: Dell Device 0c42
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 124
        IOMMU group: 12
        Bus: primary=00, secondary=03, subordinate=6c, sec-latency=0
        I/O behind bridge: 4000-6fff [size=12K] [16-bit]
        Memory behind bridge: 64000000-920fffff [size=737M] [32-bit]
        Prefetchable memory behind bridge: 6000000000-604a0fffff [size=1185M] [32-bit]
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- RBE+ TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
                LnkCap: Port #17, Speed 8GT/s, Width x4, ASPM L1, Exit Latency L1 <64us
                        ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
                LnkCtl: ASPM Disabled; RCB 64 bytes, LnkDisable- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 8GT/s, Width x4
                        TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt+
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #16, PowerLimit 25W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+ LinkChg+
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCap: CRSVisible-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range ABC, TimeoutDis+ NROPrPrP- LTR+
                         10BitTagComp- 10BitTagReq- OBFF Via WAKE#, ExtFmt+ EETLPPrefix+, MaxEETLPPrefixes 2
                         EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
                         FRS- LN System CLS Not Supported, TPHComp- ExtTPHComp- ARIFwd+
                         AtomicOpsCap: Routing- 32bit- 64bit- 128bitCAS-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
                         AtomicOpsCtl: ReqEn- EgressBlck-
                         IDOReq- IDOCompl- LTR+ EmergencyPowerReductionReq-
                         10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
                LnkCap2: Supported Link Speeds: 2.5-8GT/s, Crosslink- Retimer+ 2Retimers+ DRS-
                LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB preshoot
                LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete+ EqualizationPhase1+
                         EqualizationPhase2+ EqualizationPhase3+ LinkEqualizationRequest-
                         Retimer- 2Retimers- CrosslinkRes: unsupported
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee00298  Data: 0000
        Capabilities: [98] Subsystem: Dell Device 0c42
        Capabilities: [a0] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100 v0] Null
        Capabilities: [220 v1] Access Control Services
                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
                ACSCtl: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
        Capabilities: [150 v1] Precision Time Measurement
                PTMCap: Requester- Responder+ Root+
                PTMClockGranularity: 4ns
                PTMControl: Enabled+ RootSelected+
                PTMEffectiveGranularity: Unknown
        Capabilities: [a30 v1] Secondary PCI Express
                LnkCtl3: LnkEquIntrruptEn- PerformEqu-
                LaneErrStat: 0
        Capabilities: [a90 v1] Data Link Feature <?>
        Kernel driver in use: pcieport

00:1c.0 PCI bridge: Intel Corporation Raptor Point-S PCH - PCI Express Root Port 3 (rev 11) (prog-if 00 [Normal decode])
        Subsystem: Dell Device 0c42
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 125
        IOMMU group: 13
        Bus: primary=00, secondary=6d, subordinate=6d, sec-latency=0
        I/O behind bridge: f000-0fff [disabled] [16-bit]
        Memory behind bridge: 92100000-921fffff [size=1M] [32-bit]
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff [disabled] [64-bit]
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- RBE+ TEE-IO-
                DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 256 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
                LnkCap: Port #3, Speed 8GT/s, Width x1, ASPM L1, Exit Latency L1 <64us
                        ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes, LnkDisable- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 8GT/s, Width x1
                        TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
                        Slot #2, PowerLimit 10W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCap: CRSVisible-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range ABC, TimeoutDis+ NROPrPrP- LTR+
                         10BitTagComp- 10BitTagReq- OBFF Via WAKE#, ExtFmt+ EETLPPrefix+, MaxEETLPPrefixes 2
                         EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
                         FRS- LN System CLS Not Supported, TPHComp- ExtTPHComp- ARIFwd+
                         AtomicOpsCap: Routing- 32bit- 64bit- 128bitCAS-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
                         AtomicOpsCtl: ReqEn- EgressBlck-
                         IDOReq- IDOCompl- LTR+ EmergencyPowerReductionReq-
                         10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
                LnkCap2: Supported Link Speeds: 2.5-8GT/s, Crosslink- Retimer+ 2Retimers+ DRS-
                LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB preshoot
                LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete+ EqualizationPhase1+
                         EqualizationPhase2+ EqualizationPhase3+ LinkEqualizationRequest-
                         Retimer- 2Retimers- CrosslinkRes: unsupported
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee002b8  Data: 0000
        Capabilities: [98] Subsystem: Dell Device 0c42
        Capabilities: [a0] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UESvrt: DLP+ SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr- CorrIntErr- HeaderOF-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+ CorrIntErr- HeaderOF-
                AERCap: First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 00000000 00000000 00000000 00000000
                RootCmd: CERptEn+ NFERptEn+ FERptEn+
                RootSta: CERcvd- MultCERcvd- UERcvd- MultUERcvd-
                         FirstFatal- NonFatalMsg- FatalMsg- IntMsgNum 0
                ErrorSrc: ERR_COR: 0000 ERR_FATAL/NONFATAL: 0000
        Capabilities: [220 v1] Access Control Services
                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
                ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
        Capabilities: [200 v1] L1 PM Substates
                L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
                          PortCommonModeRestoreTime=60us PortTPowerOnTime=42us
                L1SubCtl1: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+
                           T_CommonMode=60us LTR1.2_Threshold=126976ns
                L1SubCtl2: T_PwrOn=60us
        Capabilities: [150 v1] Precision Time Measurement
                PTMCap: Requester- Responder+ Root+
                PTMClockGranularity: 4ns
                PTMControl: Enabled+ RootSelected+
                PTMEffectiveGranularity: Unknown
        Capabilities: [a30 v1] Secondary PCI Express
                LnkCtl3: LnkEquIntrruptEn- PerformEqu-
                LaneErrStat: 0
        Capabilities: [a90 v1] Data Link Feature <?>
        Kernel driver in use: pcieport

00:1f.0 ISA bridge: Intel Corporation Device 7a0d (rev 11)
        Subsystem: Dell Device 0c42
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        IOMMU group: 14

00:1f.3 Audio device: Intel Corporation Raptor Lake High Definition Audio Controller (rev 11) (prog-if 80)
        Subsystem: Dell Device 0c42
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Interrupt: pin B routed to IRQ 199
        IOMMU group: 14
        Region 0: Memory at 604c150000 (64-bit, non-prefetchable) [size=16K]
        Region 4: Memory at 604c000000 (64-bit, non-prefetchable) [size=1M]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D3 NoSoftRst+ PME-Enable+ DSel=0 DScale=0 PME-
        Capabilities: [80] Vendor Specific Information: Len=14 <?>
        Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee00c38  Data: 0000
        Kernel driver in use: snd_hda_intel
        Kernel modules: snd_hda_intel, snd_soc_avs, snd_sof_pci_intel_tgl

00:1f.4 SMBus: Intel Corporation Raptor Lake-S PCH SMBus Controller (rev 11)
        Subsystem: Dell Device 0c42
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin C routed to IRQ 18
        IOMMU group: 14
        Region 0: Memory at 604c15c000 (64-bit, non-prefetchable) [size=256]
        Region 4: I/O ports at efa0 [size=32]
        Kernel driver in use: i801_smbus
        Kernel modules: i2c_i801

00:1f.5 Serial bus controller: Intel Corporation Raptor Lake SPI (flash) Controller (rev 11)
        Subsystem: Dell Device 0c42
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        IOMMU group: 14
        Region 0: Memory at 60800000 (32-bit, non-prefetchable) [size=4K]

00:1f.6 Ethernet controller: Intel Corporation Device 0dc7 (rev 11)
        Subsystem: Dell Device 0c42
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin D routed to IRQ 233
        IOMMU group: 14
        Region 0: Memory at 92400000 (32-bit, non-prefetchable) [size=128K]
        Capabilities: [c8] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee01078  Data: 0000
        Kernel driver in use: e1000e
        Kernel modules: e1000e

01:00.0 Non-Volatile memory controller: Sandisk Corp WD Black SN850X NVMe SSD (rev 01) (prog-if 02 [NVM Express])
        Subsystem: Sandisk Corp WD Black SN850X NVMe SSD
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        IOMMU group: 15
        Region 0: Memory at 92300000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] MSI: Enable- Count=1/32 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [b0] MSI-X: Enable+ Count=65 Masked-
                Vector table: BAR=0 offset=00003000
                PBA: BAR=0 offset=00002000
        Capabilities: [c0] Express (v2) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <1us, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0W TEE-IO-
                DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
                        MaxPayload 256 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
                LnkCap: Port #0, Speed 16GT/s, Width x4, ASPM L1, Exit Latency L1 <8us
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes, LnkDisable- CommClk+
                        ExtSynch+ ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 16GT/s, Width x4
                        TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range B, TimeoutDis+ NROPrPrP- LTR+
                         10BitTagComp+ 10BitTagReq- OBFF Not Supported, ExtFmt+ EETLPPrefix-
                         EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
                         FRS- TPHComp- ExtTPHComp-
                         AtomicOpsCap: 32bit- 64bit- 128bitCAS-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                         AtomicOpsCtl: ReqEn-
                         IDOReq- IDOCompl- LTR+ EmergencyPowerReductionReq-
                         10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
                LnkCap2: Supported Link Speeds: 2.5-16GT/s, Crosslink- Retimer+ 2Retimers+ DRS-
                LnkCtl2: Target Link Speed: 16GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB preshoot
                LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete+ EqualizationPhase1+
                         EqualizationPhase2+ EqualizationPhase3+ LinkEqualizationRequest-
                         Retimer- 2Retimers- CrosslinkRes: unsupported
        Capabilities: [100 v2] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr+ BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
                        ECRC- UnsupReq- ACSViol- UncorrIntErr+ BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr- CorrIntErr- HeaderOF-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+ CorrIntErr+ HeaderOF+
                AERCap: First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 00000000 00000000 00000000 00000000
        Capabilities: [1b8 v1] Latency Tolerance Reporting
                Max snoop latency: 15728640ns
                Max no snoop latency: 15728640ns
        Capabilities: [300 v1] Secondary PCI Express
                LnkCtl3: LnkEquIntrruptEn- PerformEqu-
                LaneErrStat: 0
        Capabilities: [900 v1] L1 PM Substates
                L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1- L1_PM_Substates+
                          PortCommonModeRestoreTime=32us PortTPowerOnTime=10us
                L1SubCtl1: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1-
                           T_CommonMode=0us LTR1.2_Threshold=616448ns
                L1SubCtl2: T_PwrOn=500us
        Capabilities: [910 v1] Data Link Feature <?>
        Capabilities: [920 v1] Lane Margining at the Receiver
                PortCap: Uses Driver+
                PortSta: MargReady+ MargSoftReady+
        Capabilities: [9c0 v1] Physical Layer 16.0 GT/s <?>
        Kernel driver in use: nvme
        Kernel modules: nvme

02:00.0 Non-Volatile memory controller: Kingston Technology Company, Inc. NV2 NVMe SSD [E21T] (DRAM-less) (prog-if 02 [NVM Express])
        Subsystem: Kingston Technology Company, Inc. NV2 NVMe SSD [E21T] (DRAM-less)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        IOMMU group: 16
        Region 0: Memory at 92200000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [80] Express (v2) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 25W TEE-IO-
                DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
                        RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+ FLReset-
                        MaxPayload 256 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr- TransPend-
                LnkCap: Port #1, Speed 16GT/s, Width x4, ASPM L1, Exit Latency L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes, LnkDisable- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 16GT/s, Width x4
                        TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ NROPrPrP- LTR+
                         10BitTagComp+ 10BitTagReq- OBFF Not Supported, ExtFmt+ EETLPPrefix-
                         EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
                         FRS- TPHComp- ExtTPHComp-
                         AtomicOpsCap: 32bit- 64bit- 128bitCAS-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                         AtomicOpsCtl: ReqEn-
                         IDOReq- IDOCompl- LTR+ EmergencyPowerReductionReq-
                         10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
                LnkCap2: Supported Link Speeds: 2.5-16GT/s, Crosslink- Retimer+ 2Retimers+ DRS-
                LnkCtl2: Target Link Speed: 16GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB preshoot
                LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete+ EqualizationPhase1+
                         EqualizationPhase2+ EqualizationPhase3+ LinkEqualizationRequest-
                         Retimer- 2Retimers- CrosslinkRes: Upstream Port
        Capabilities: [d0] MSI-X: Enable+ Count=17 Masked-
                Vector table: BAR=0 offset=00002000
                PBA: BAR=0 offset=00003000
        Capabilities: [e0] MSI: Enable- Count=1/16 Maskable+ 64bit+
                Address: 0000000000000000  Data: 0000
                Masking: 00000000  Pending: 00000000
        Capabilities: [f8] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [100 v1] Latency Tolerance Reporting
                Max snoop latency: 3145728ns
                Max no snoop latency: 3145728ns
        Capabilities: [110 v1] L1 PM Substates
                L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
                          PortCommonModeRestoreTime=10us PortTPowerOnTime=300us
                L1SubCtl1: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+
                           T_CommonMode=0us LTR1.2_Threshold=366592ns
                L1SubCtl2: T_PwrOn=300us
        Capabilities: [128 v1] Alternative Routing-ID Interpretation (ARI)
                ARICap: MFVC- ACS-, Next Function: 0
                ARICtl: MFVC- ACS-, Function Group: 0
        Capabilities: [1e0 v1] Data Link Feature <?>
        Capabilities: [200 v2] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr+ BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
                        ECRC- UnsupReq- ACSViol- UncorrIntErr+ BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr- CorrIntErr- HeaderOF-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+ CorrIntErr+ HeaderOF-
                AERCap: First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap+ ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 04000001 0000000f 02070000 884a1f9f
        Capabilities: [300 v1] Secondary PCI Express
                LnkCtl3: LnkEquIntrruptEn- PerformEqu-
                LaneErrStat: 0
        Capabilities: [340 v1] Physical Layer 16.0 GT/s <?>
        Capabilities: [378 v1] Lane Margining at the Receiver
                PortCap: Uses Driver-
                PortSta: MargReady+ MargSoftReady-
        Kernel driver in use: nvme
        Kernel modules: nvme

03:00.0 PCI bridge: Intel Corporation Thunderbolt 4 Bridge [Maple Ridge 4C 2020] (rev 02) (prog-if 00 [Normal decode])
        Subsystem: Dell Device 0c42
        Physical Slot: 16
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        IOMMU group: 17
        Bus: primary=03, secondary=04, subordinate=6c, sec-latency=0
        I/O behind bridge: 4000-5fff [size=8K] [16-bit]
        Memory behind bridge: 64000000-91efffff [size=735M] [32-bit]
        Prefetchable memory behind bridge: 6000000000-604a0fffff [size=1185M] [32-bit]
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [88] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [ac] Subsystem: Dell Device 0c42
        Capabilities: [c0] Express (v2) Upstream Port, IntMsgNum 0
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ SlotPowerLimit 25W TEE-IO-
                DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
                        RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 8GT/s, Width x4, ASPM L0s L1, Exit Latency L0s <2us, L1 <4us
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
                LnkCtl: ASPM Disabled; LnkDisable- CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 8GT/s, Width x4
                        TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis- NROPrPrP- LTR+
                         10BitTagComp- 10BitTagReq- OBFF Not Supported, ExtFmt- EETLPPrefix-
                         EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
                         FRS-
                         AtomicOpsCap: Routing-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                         AtomicOpsCtl: EgressBlck-
                         IDOReq- IDOCompl- LTR+ EmergencyPowerReductionReq-
                         10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
                LnkCap2: Supported Link Speeds: 2.5-8GT/s, Crosslink- Retimer- 2Retimers- DRS-
                LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB preshoot
                LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete+ EqualizationPhase1+
                         EqualizationPhase2+ EqualizationPhase3+ LinkEqualizationRequest-
                         Retimer- 2Retimers- CrosslinkRes: unsupported
        Capabilities: [50] Capability ID 0x15 [0000]
        Capabilities: [100 v1] Device Serial Number 26-1f-84-e2-39-00-aa-00
        Capabilities: [200 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
                        ECRC- UnsupReq- ACSViol- UncorrIntErr+ BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr- CorrIntErr- HeaderOF-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+ CorrIntErr- HeaderOF-
                AERCap: First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 00000000 00000000 00000000 00000000
        Capabilities: [300 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Capabilities: [400 v1] Power Budgeting <?>
        Capabilities: [500 v1] Vendor Specific Information: ID=1234 Rev=1 Len=100 <?>
        Capabilities: [600 v1] Vendor Specific Information: ID=8086 Rev=2 Len=064 <?>
        Capabilities: [700 v1] Secondary PCI Express
                LnkCtl3: LnkEquIntrruptEn- PerformEqu-
                LaneErrStat: 0
        Capabilities: [800 v1] Latency Tolerance Reporting
                Max snoop latency: 3145728ns
                Max no snoop latency: 3145728ns
        Capabilities: [a00 v1] L1 PM Substates
                L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
                          PortCommonModeRestoreTime=0us PortTPowerOnTime=10us
                L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
                           T_CommonMode=0us LTR1.2_Threshold=0ns
                L1SubCtl2: T_PwrOn=10us
        Capabilities: [b00 v2] Precision Time Measurement
                PTMCap: Requester+ Responder+ Root-
                PTMClockGranularity: Unimplemented
                PTMControl: Enabled+ RootSelected-
                PTMEffectiveGranularity: 4ns
        Kernel driver in use: pcieport

04:00.0 PCI bridge: Intel Corporation Thunderbolt 4 Bridge [Maple Ridge 4C 2020] (rev 02) (prog-if 00 [Normal decode])
        Subsystem: Dell Device 0c42
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 126
        IOMMU group: 18
        Bus: primary=04, secondary=05, subordinate=05, sec-latency=0
        I/O behind bridge: 0000f000-00000fff [disabled] [32-bit]
        Memory behind bridge: fff00000-000fffff [disabled] [32-bit]
        Prefetchable memory behind bridge: 604a000000-604a0fffff [size=1M] [32-bit]
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [88] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee002d8  Data: 0000
        Capabilities: [ac] Subsystem: Dell Device 0c42
        Capabilities: [c0] Express (v2) Downstream Port (Slot+), IntMsgNum 0
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag+ RBE+ TEE-IO-
                DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
                        RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Exit Latency L0s <2us, L1 <4us
                        ClockPM- Surprise- LLActRep- BwNot+ ASPMOptComp+
                LnkCtl: ASPM L1 Enabled; LnkDisable- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4
                        TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
                        Slot #0, PowerLimit 0W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis- NROPrPrP- LTR+
                         10BitTagComp- 10BitTagReq- OBFF Not Supported, ExtFmt- EETLPPrefix-
                         EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
                         FRS- ARIFwd-
                         AtomicOpsCap: Routing-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
                         AtomicOpsCtl: EgressBlck-
                         IDOReq- IDOCompl- LTR+ EmergencyPowerReductionReq-
                         10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
                LnkCap2: Supported Link Speeds: 2.5GT/s, Crosslink- Retimer- 2Retimers- DRS-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB preshoot
                LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete- EqualizationPhase1-
                         EqualizationPhase2- EqualizationPhase3- LinkEqualizationRequest-
                         Retimer- 2Retimers- CrosslinkRes: unsupported
        Capabilities: [50] Capability ID 0x15 [0000]
        Capabilities: [100 v1] Device Serial Number 26-1f-84-e2-39-00-aa-00
        Capabilities: [200 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
                        ECRC- UnsupReq- ACSViol- UncorrIntErr+ BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr- CorrIntErr- HeaderOF-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+ CorrIntErr- HeaderOF-
                AERCap: First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 00000000 00000000 00000000 00000000
        Capabilities: [300 v1] Virtual Channel
                Caps:   LPEVC=1 RefClk=100ns PATEntryBits=1
                Arb:    Fixed+ WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
                VC1:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable- ID=1 ArbSelect=Fixed TC/VC=00
                        Status: NegoPending+ InProgress-
        Capabilities: [400 v1] Power Budgeting <?>
        Capabilities: [500 v1] Vendor Specific Information: ID=1234 Rev=1 Len=100 <?>
        Capabilities: [600 v1] Vendor Specific Information: ID=8086 Rev=2 Len=064 <?>
        Capabilities: [900 v1] Access Control Services
                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl+ DirectTrans+
                ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
        Capabilities: [c00 v1] Designated Vendor-Specific: Vendor=8086 ID=0006 Rev=0 Len=16 <?>
        Kernel driver in use: pcieport

04:01.0 PCI bridge: Intel Corporation Thunderbolt 4 Bridge [Maple Ridge 4C 2020] (rev 02) (prog-if 00 [Normal decode])
        Subsystem: Dell Device 0c42
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 127
        IOMMU group: 19
        Bus: primary=04, secondary=06, subordinate=38, sec-latency=0
        I/O behind bridge: 4000-4fff [size=4K] [16-bit]
        Memory behind bridge: 7b000000-91efffff [size=367M] [32-bit]
        Prefetchable memory behind bridge: 6025000000-6049ffffff [size=592M] [32-bit]
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D3 NoSoftRst+ PME-Enable+ DSel=0 DScale=0 PME-
        Capabilities: [88] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee00318  Data: 0000
        Capabilities: [ac] Subsystem: Dell Device 0c42
        Capabilities: [c0] Express (v2) Downstream Port (Slot+), IntMsgNum 0
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag+ RBE+ TEE-IO-
                DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
                        RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x4, ASPM L1, Exit Latency L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
                LnkCtl: ASPM L1 Enabled; LnkDisable- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4
                        TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #1, PowerLimit 0W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis- NROPrPrP- LTR+
                         10BitTagComp- 10BitTagReq- OBFF Not Supported, ExtFmt- EETLPPrefix-
                         EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
                         FRS- ARIFwd-
                         AtomicOpsCap: Routing-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
                         AtomicOpsCtl: EgressBlck-
                         IDOReq- IDOCompl- LTR- EmergencyPowerReductionReq-
                         10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
                LnkCap2: Supported Link Speeds: 2.5GT/s, Crosslink- Retimer- 2Retimers- DRS-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB preshoot
                LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete- EqualizationPhase1-
                         EqualizationPhase2- EqualizationPhase3- LinkEqualizationRequest-
                         Retimer- 2Retimers- CrosslinkRes: unsupported
        Capabilities: [50] Capability ID 0x15 [0000]
        Capabilities: [100 v1] Device Serial Number 26-1f-84-e2-39-00-aa-00
        Capabilities: [200 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
                        ECRC- UnsupReq- ACSViol- UncorrIntErr+ BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr- CorrIntErr- HeaderOF-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+ CorrIntErr- HeaderOF-
                AERCap: First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 00000000 00000000 00000000 00000000
        Capabilities: [300 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending+ InProgress-
        Capabilities: [400 v1] Power Budgeting <?>
        Capabilities: [500 v1] Vendor Specific Information: ID=1234 Rev=1 Len=100 <?>
        Capabilities: [600 v1] Vendor Specific Information: ID=8086 Rev=2 Len=064 <?>
        Capabilities: [900 v1] Access Control Services
                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl+ DirectTrans+
                ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
        Capabilities: [c00 v1] Designated Vendor-Specific: Vendor=8086 ID=0006 Rev=0 Len=16 <?>
        Kernel driver in use: pcieport

04:02.0 PCI bridge: Intel Corporation Thunderbolt 4 Bridge [Maple Ridge 4C 2020] (rev 02) (prog-if 00 [Normal decode])
        Subsystem: Dell Device 0c42
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 128
        IOMMU group: 20
        Bus: primary=04, secondary=39, subordinate=39, sec-latency=0
        I/O behind bridge: 0000f000-00000fff [disabled] [32-bit]
        Memory behind bridge: 7af00000-7affffff [size=1M] [32-bit]
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff [disabled] [64-bit]
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D3 NoSoftRst+ PME-Enable+ DSel=0 DScale=0 PME-
        Capabilities: [88] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee00338  Data: 0000
        Capabilities: [ac] Subsystem: Dell Device 0c42
        Capabilities: [c0] Express (v2) Downstream Port (Slot+), IntMsgNum 0
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag+ RBE+ TEE-IO-
                DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
                        RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
                LnkCap: Port #2, Speed 2.5GT/s, Width x4, ASPM L0s L1, Exit Latency L0s <2us, L1 <4us
                        ClockPM- Surprise- LLActRep- BwNot+ ASPMOptComp+
                LnkCtl: ASPM L1 Enabled; LnkDisable- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x4
                        TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
                        Slot #0, PowerLimit 0W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis- NROPrPrP- LTR+
                         10BitTagComp- 10BitTagReq- OBFF Not Supported, ExtFmt- EETLPPrefix-
                         EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
                         FRS- ARIFwd-
                         AtomicOpsCap: Routing-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
                         AtomicOpsCtl: EgressBlck-
                         IDOReq- IDOCompl- LTR+ EmergencyPowerReductionReq-
                         10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
                LnkCap2: Supported Link Speeds: 2.5GT/s, Crosslink- Retimer- 2Retimers- DRS-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB preshoot
                LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete- EqualizationPhase1-
                         EqualizationPhase2- EqualizationPhase3- LinkEqualizationRequest-
                         Retimer- 2Retimers- CrosslinkRes: unsupported
        Capabilities: [50] Capability ID 0x15 [0000]
        Capabilities: [100 v1] Device Serial Number 26-1f-84-e2-39-00-aa-00
        Capabilities: [200 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
                        ECRC- UnsupReq- ACSViol- UncorrIntErr+ BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr- CorrIntErr- HeaderOF-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+ CorrIntErr- HeaderOF-
                AERCap: First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 00000000 00000000 00000000 00000000
        Capabilities: [300 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Capabilities: [400 v1] Power Budgeting <?>
        Capabilities: [500 v1] Vendor Specific Information: ID=1234 Rev=1 Len=100 <?>
        Capabilities: [900 v1] Access Control Services
                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl+ DirectTrans+
                ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
        Capabilities: [c00 v1] Designated Vendor-Specific: Vendor=8086 ID=0006 Rev=0 Len=16 <?>
        Kernel driver in use: pcieport

04:03.0 PCI bridge: Intel Corporation Thunderbolt 4 Bridge [Maple Ridge 4C 2020] (rev 02) (prog-if 00 [Normal decode])
        Subsystem: Dell Device 0c42
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 129
        IOMMU group: 21
        Bus: primary=04, secondary=3a, subordinate=6c, sec-latency=0
        I/O behind bridge: 5000-5fff [size=4K] [16-bit]
        Memory behind bridge: 64000000-7aefffff [size=367M] [32-bit]
        Prefetchable memory behind bridge: 6000000000-6024ffffff [size=592M] [32-bit]
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D3 NoSoftRst+ PME-Enable+ DSel=0 DScale=0 PME-
        Capabilities: [88] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee00358  Data: 0000
        Capabilities: [ac] Subsystem: Dell Device 0c42
        Capabilities: [c0] Express (v2) Downstream Port (Slot+), IntMsgNum 0
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag+ RBE+ TEE-IO-
                DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
                        RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
                LnkCap: Port #3, Speed 2.5GT/s, Width x4, ASPM L1, Exit Latency L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
                LnkCtl: ASPM L1 Enabled; LnkDisable- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4
                        TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #3, PowerLimit 0W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis- NROPrPrP- LTR+
                         10BitTagComp- 10BitTagReq- OBFF Not Supported, ExtFmt- EETLPPrefix-
                         EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
                         FRS- ARIFwd-
                         AtomicOpsCap: Routing-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
                         AtomicOpsCtl: EgressBlck-
                         IDOReq- IDOCompl- LTR- EmergencyPowerReductionReq-
                         10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
                LnkCap2: Supported Link Speeds: 2.5GT/s, Crosslink- Retimer- 2Retimers- DRS-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB preshoot
                LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete- EqualizationPhase1-
                         EqualizationPhase2- EqualizationPhase3- LinkEqualizationRequest-
                         Retimer- 2Retimers- CrosslinkRes: unsupported
        Capabilities: [50] Capability ID 0x15 [0000]
        Capabilities: [100 v1] Device Serial Number 26-1f-84-e2-39-00-aa-00
        Capabilities: [200 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
                        ECRC- UnsupReq- ACSViol- UncorrIntErr+ BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr- CorrIntErr- HeaderOF-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+ CorrIntErr- HeaderOF-
                AERCap: First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 00000000 00000000 00000000 00000000
        Capabilities: [300 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending+ InProgress-
        Capabilities: [400 v1] Power Budgeting <?>
        Capabilities: [500 v1] Vendor Specific Information: ID=1234 Rev=1 Len=100 <?>
        Capabilities: [600 v1] Vendor Specific Information: ID=8086 Rev=2 Len=064 <?>
        Capabilities: [900 v1] Access Control Services
                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl+ DirectTrans+
                ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
        Capabilities: [c00 v1] Designated Vendor-Specific: Vendor=8086 ID=0006 Rev=0 Len=16 <?>
        Kernel driver in use: pcieport

05:00.0 USB controller: Intel Corporation Thunderbolt 4 NHI [Maple Ridge 4C 2020] (prog-if 40 [USB4 Host Interface])
        Subsystem: Dell Device 0c42
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        IOMMU group: 22
        Region 0: Memory at 604a000000 (64-bit, prefetchable) [size=256K]
        Region 2: Memory at 604a040000 (64-bit, prefetchable) [size=4K]
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [88] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [c0] Express (v2) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset- SlotPowerLimit 0W TEE-IO-
                DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
                        RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L1, Exit Latency L1 <1us
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes, LnkDisable- CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4
                        TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range B, TimeoutDis+ NROPrPrP- LTR+
                         10BitTagComp- 10BitTagReq- OBFF Not Supported, ExtFmt- EETLPPrefix-
                         EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
                         FRS- TPHComp- ExtTPHComp-
                         AtomicOpsCap: 32bit- 64bit- 128bitCAS-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                         AtomicOpsCtl: ReqEn-
                         IDOReq- IDOCompl- LTR+ EmergencyPowerReductionReq-
                         10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB preshoot
                LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete- EqualizationPhase1-
                         EqualizationPhase2- EqualizationPhase3- LinkEqualizationRequest-
                         Retimer- 2Retimers- CrosslinkRes: unsupported
        Capabilities: [a0] MSI-X: Enable+ Count=16 Masked-
                Vector table: BAR=2 offset=00000000
                PBA: BAR=2 offset=00000fa0
        Capabilities: [100 v1] Device Serial Number 26-1f-84-e2-39-00-aa-00
        Capabilities: [200 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr- CorrIntErr- HeaderOF-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+ CorrIntErr- HeaderOF-
                AERCap: First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 00000000 00000000 00000000 00000000
        Capabilities: [300 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Capabilities: [400 v1] Power Budgeting <?>
        Capabilities: [500 v1] Vendor Specific Information: ID=1234 Rev=1 Len=100 <?>
        Capabilities: [600 v1] Latency Tolerance Reporting
                Max snoop latency: 3145728ns
                Max no snoop latency: 3145728ns
        Kernel driver in use: thunderbolt
        Kernel modules: thunderbolt

39:00.0 USB controller: Intel Corporation Thunderbolt 4 USB Controller [Maple Ridge 4C 2020] (prog-if 30 [XHCI])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin ? routed to IRQ 208
        IOMMU group: 23
        Region 0: Memory at 7af00000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D3 NoSoftRst+ PME-Enable+ DSel=0 DScale=0 PME-
        Capabilities: [80] MSI: Enable+ Count=8/8 Maskable- 64bit+
                Address: 00000000fee00e18  Data: 0000
        Capabilities: [90] Vendor Specific Information: Len=14 <?>
        Capabilities: [b0] Vendor Specific Information: Len=00 <?>
        Capabilities: [bc] Express (v2) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <2us, L1 <8us
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset- SlotPowerLimit 0W TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L1, Exit Latency L1 <1us
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes, LnkDisable- CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4
                        TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis+ NROPrPrP- LTR+
                         10BitTagComp- 10BitTagReq- OBFF Not Supported, ExtFmt- EETLPPrefix-
                         EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
                         FRS- TPHComp- ExtTPHComp-
                         AtomicOpsCap: 32bit- 64bit- 128bitCAS-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                         AtomicOpsCtl: ReqEn-
                         IDOReq- IDOCompl- LTR+ EmergencyPowerReductionReq-
                         10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
                LnkCap2: Supported Link Speeds: 2.5-8GT/s, Crosslink- Retimer- 2Retimers- DRS-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB preshoot
                LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete- EqualizationPhase1-
                         EqualizationPhase2- EqualizationPhase3- LinkEqualizationRequest-
                         Retimer- 2Retimers- CrosslinkRes: unsupported
        Capabilities: [100 v1] Latency Tolerance Reporting
                Max snoop latency: 3145728ns
                Max no snoop latency: 3145728ns
        Kernel driver in use: xhci_hcd
        Kernel modules: xhci_pci

6d:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS5260 PCI Express Card Reader (rev 01)
        Subsystem: Dell Device 0c42
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 180
        IOMMU group: 24
        Region 0: Memory at 92100000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee009b8  Data: 0000
        Capabilities: [70] Express (v2) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- SlotPowerLimit 10W TEE-IO-
                DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 256 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 8GT/s, Width x1, ASPM L0s L1, Exit Latency L0s unlimited, L1 unlimited
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes, LnkDisable- CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 8GT/s, Width x1
                        TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis+ NROPrPrP- LTR+
                         10BitTagComp- 10BitTagReq- OBFF Via message/WAKE#, ExtFmt- EETLPPrefix-
                         EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
                         FRS- TPHComp- ExtTPHComp-
                         AtomicOpsCap: 32bit- 64bit- 128bitCAS-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                         AtomicOpsCtl: ReqEn-
                         IDOReq- IDOCompl- LTR+ EmergencyPowerReductionReq-
                         10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
                LnkCap2: Supported Link Speeds: 2.5-8GT/s, Crosslink- Retimer- 2Retimers- DRS-
                LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB preshoot
                LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete+ EqualizationPhase1+
                         EqualizationPhase2+ EqualizationPhase3+ LinkEqualizationRequest-
                         Retimer- 2Retimers- CrosslinkRes: unsupported
        Capabilities: [100 v2] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
                        ECRC- UnsupReq- ACSViol- UncorrIntErr+ BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
                        ECRC- UnsupReq- ACSViol- UncorrIntErr+ BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
                        PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr- CorrIntErr- HeaderOF-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+ CorrIntErr+ HeaderOF+
                AERCap: First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 00000000 00000000 00000000 00000000
        Capabilities: [148 v1] Device Serial Number 00-00-00-01-00-4c-e0-00
        Capabilities: [158 v1] Secondary PCI Express
                LnkCtl3: LnkEquIntrruptEn- PerformEqu-
                LaneErrStat: 0
        Capabilities: [168 v1] Latency Tolerance Reporting
                Max snoop latency: 3145728ns
                Max no snoop latency: 3145728ns
        Capabilities: [170 v1] L1 PM Substates
                L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
                          PortCommonModeRestoreTime=60us PortTPowerOnTime=60us
                L1SubCtl1: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+
                           T_CommonMode=0us LTR1.2_Threshold=126976ns
                L1SubCtl2: T_PwrOn=60us
        Kernel driver in use: rtsx_pci
        Kernel modules: rtsx_pci



-- 
Askar Safin

