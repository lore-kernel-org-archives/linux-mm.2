Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E124FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 21:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921776B008C; Wed, 29 Apr 2026 17:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8C46B0092; Wed, 29 Apr 2026 17:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836806B0093; Wed, 29 Apr 2026 17:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 746C26B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:22:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1524B4012D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:22:29 +0000 (UTC)
X-FDA: 84712867218.24.25AA3D1
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3423212000E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:22:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A+elp8aF;
	spf=pass (imf29.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777497747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fi2jtxPM+vxOvAFAOVnwPs3gIOYE8Xix9RkoDR4vGnA=;
	b=kba+ZKNVA8eC/VK7gqYuBrAnIPYdwprBBdxVZkMI7EMcrbi9kBsUMZiYMsymIwasGAxt/r
	5rpTnWHua2hIvxtmqzFIuaE0o7h7MecyXaRkof5St/s886B2vaDPp/E2prITmXrhZj8rtB
	P0qKEWrQY6OYX9cFP/m85zi7Pnx0wWM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777497747; a=rsa-sha256;
	cv=none;
	b=t3FNBigpgO5QtrQBNuLJBp30LbfLWo7HIbyD241TlrNyZM1se77fPOo0vu/m9bFVO1uBh3
	I0tdL1M5kP698NNbHYmrfArgPS6fg5iNU2one4PbRfiQEWYbYO45OjK3XGkTJJ2A182gy0
	9Imqb47PXIn6dnAQred0QdFE1mgq6RE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A+elp8aF;
	spf=pass (imf29.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43cfce3a195so136788f8f.2
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777497746; x=1778102546; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fi2jtxPM+vxOvAFAOVnwPs3gIOYE8Xix9RkoDR4vGnA=;
        b=A+elp8aFlO+7Ak466x7RWjPirkO16lNwi0TSzx3pFkpwZ/uG0TneeoZtT+YEQCocd4
         n/2VgyYph/fhu8vAId2BZUEA6UidLnw+1790gthxtweMoGbXiJlncXIzCQNiGEX4EiTQ
         u/fFj/P5Bd1CIr+/0mEIO3WFEeH4YlBN3AX0j9eoTGZfmoYR40amhUF7p90IyR8znhZ0
         qGeDs3tMldKQBp4NxiBJWulkOxAnykuslpj5ItkhX7lpPL5RUZcr366iaSP27zD6srXh
         wxIFam/cF7ilmVXIDAWPfQpNOaGQxaa2axAvuvPpQsYdtLUMTuTi/O2MRTuEkUB7BpfV
         KVjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777497746; x=1778102546;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fi2jtxPM+vxOvAFAOVnwPs3gIOYE8Xix9RkoDR4vGnA=;
        b=BE08TeohwFctCs8zvWkmvDaWU6JyJ4zfilPNcr9tvTO9CtpV/jT8iDn+3kxjuyWMDx
         8zLajhaNfgLaHtIFRrjVx7Tczm/ocEoPVCEei3t4mLgCL/IUwrZNlE5BMHgEIpV5rvRi
         fSjINoFGUoF8MdVVoTFGyoqrDCZtq/U1LvgVwyfqgkz8Uo8ua/6CqOY0BFp8ZvESDZ56
         VSWRkDXHq1zsLlUS3yv44+ePVdQT/j5oGH67T88IdJYii057zsAlPFny0Lyzw0XFqVvg
         Nwyaeu0drmAqVbBk/xfF6jCYNFcKZi58UPou+euTkLD3gyds4zpNzHZaG0hirTwPayhB
         70uQ==
X-Gm-Message-State: AOJu0YwW5WeGAXryCvxNsSMeWF9bPT7wFdE96+tVxUXDhaPxs8pT5z25
	UizjU+sMsCdM1gkZCnsXKDBF1IDmfkLxUQWJjs9UaamdbpX2bXd6LZ4Z
X-Gm-Gg: AeBDiesoWOBUDJMDBj7IKJfwpHuyyqd1Zwd645jWExUI66rZZFYT007Ikv8BMODKDYM
	0J8y5b4DhVDqBsS370xQPBd0ZPSW25+qLdMJuD+lDopLigGVJTkUdmrrw5podQWwiI5DatG/jJR
	GiOoOIbLCokDQ+ZhduKKkcEjnzUVpm1hJftCxeU8h+EEy3r5fqf0ovBss/F9WGBpiKtT3rB8iCF
	KNfY2SDNFEwfEWU0+l42MjUiSDtM1YBwNGUTO+wxfVu8mZ+9J9XCFSJLArOzb/yZ5GV9EyN9vBB
	9cctmBVLj9N1c8MTgbtcadEOFKvl3vepqNfQKz4agFjO8cjWdWcHfTYIlYlxU2HMNELXcfUZERv
	qI2QBv4cAHUdbYgU05SDpClXf074uWF7l+1id0yubhugY7uHvKwzn80YJBHBPdEm/I4UUGOmuzl
	COIpxXjaMpD2fOcTgQYO7Z0YPyp/pTB++/ilSq+MQ=
X-Received: by 2002:a5d:5f46:0:b0:43c:ef4f:79e4 with SMTP id ffacd0b85a97d-44649ba18f0mr16916072f8f.37.1777497745370;
        Wed, 29 Apr 2026 14:22:25 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:8fc7:44bf:8aca:ebae])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-447b76e5c7csm8096196f8f.26.2026.04.29.14.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 14:22:24 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH v11 0/4] liveupdate: bug fix for session name and new ioctl to read it
Date: Wed, 29 Apr 2026 22:21:13 +0100
Message-ID: <20260429212221.814107-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3423212000E
X-Rspam-User: 
X-Stat-Signature: pwpfso3idhbq57boszwtuu1n4kxpoksx
X-HE-Tag: 1777497747-724115
X-HE-Meta: U2FsdGVkX1+iYbUKnvLRLgCTNQfQK5mh9xkx2mvrea2tEwomWpGOoMsX/4bsyvrDa1Q7ORNF2n41MtPbVy2OWvz88NI76lwCeWZtrt382f3HEcIjyyvaZ3cgH6c0F0Oq3M1rOi5PQNSVQFoSuAvYHPsGzXZbvqBfnRXLfdT3ruxy3Pzstslz3QGmKrWHmkT1Y/hZH7zkyoymfkO76hexpNlVrQ+lGIrT0TLISCjG6tAkzzjZyow5Og4Qub801k+5b4zd/hiavvG/pxkIsjeJYlxtnhdt56Dumo/aAFCR96t83xDGgyizbDhhztfatT7R7FFCnpZlIyuvWJ3331ebhbzvlZkZb41jYj9qZHYLhcvrmlXKJpy+7ULmG7SoAugok8QOqEgWlSx/87sF/5DIXOGO4nLFG7Nmu47A9U+jmHyWwR6QMI+bDY+QRkzUZ7O2BGZqxoLFXSZeJGSqruM60bICu1G/imPF3+P8JzE8toeuiSfrDbvYwRA1ciU21fUZacGf+eIcOdIhvqk0Ib6atwNmMEQyGTjDBW69eDS5UdZtkdu7t87h0MpcbNROaNZ3vDAUn6UaRXeJVIb8Y4DVZUxS4cRDAZV9hcUq+u/K5JQei8+R1wemlKgOIANWZi0qjMvlbRd0kmcs9ccrJeHCYyaAnwLN/pvT4rAosXJHpor3Ksfer3hfSyLl+Gn8tLj4vsBtmp9EhtAz52ESn+VAbq+ezoXuY86L9QSJCrQBL/cDipn84/th7AwD+0BLiqA0U47yocxm35NQOSbV9seNE7YFhcyFaN2wpavX/mmikZy4oMGJzOvozGKpcgn3FU3ck8FJmI+VY930O7HtmEhiDotnZ3O6bg1q+kGpLowD28lOTwdfxb4xhhIsUyagWn7sGMD2s6JNvbBkvNgC/nTRtkJCDs/dNjLvMjh7zL8P7uYsm07Im1WWaoiPtFuSbcugLy15Tn6TlJ1HIYLklpd
 1EvzrLOF
 FGc3sYKW4EVyXtT8UGy4UM1p365pXPK86iOQTGpNmi1Sq2QHLZV4FdK5iSpgZOEMeDBCe+77dZwU77Ximj21huSV2OBA39Qgz4V63Ub6sNJHgcfYMbJoFh0dufvt6IGKsMPbHvH6D/FDt7OTvvyNsjSpJD6hfV0gnVXvFF0STtg/wIJgkbnfzAAywFSaFAH1cc/nh3kB19zLNrUX/AM0EB4odFgRGlhdZTE6h5vIjLAdWqhf815h11VQj1LuN2+jbQZPlK+bZ0zKuYGk2NyCuSxsW9vyICNcdNvLFfpvKgr0XEUxRpAQXxSTFDgIOm9TT8AE9Pby3Fvh3RR05Z89lbTwn/HKrGyVPBvwSUT1ZPfirZC9PZPaUAaxtQrG5xk/J3tzN00yRglegbKE3n6h7I58x5qR8EirzzfYA6D3DOvXFEcqTsydyx7NqvKedn6Ja/XP4Kv0xqrsJdQUZ5DvXXQj91HcXn9HdExZ8tLLcIlqM5Y11oBAEgLbfaT4JKG98QNcsGVLhae1zyteJGtvtdZ8NN7zkW+Nk753Jczf8gq9szFN8+aD75rERTYKyaeCLOxHmYaHSzc5VHMsECDaV27k5/gEeVwHA+G53AnX3Q0a3JjEePtl3HFVPHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luca Boccassi <luca.boccassi@gmail.com>

A series of patches matured while implementing LUO support in userspace
in systemd.

- reject session names that are either empty strings or too long
- add new ioctl to retrieve session name from FD, so that userspace
  can query it without string parsing in procfs

Both changes come with a follow-up patch add test coverage via the
existing selftest.

v2: apply one fix from bot review about cleanup on error path:
    https://sashiko.dev/#/patchset/20260415184536.1155220-1-luca.boccassi%40gmail.com
    the other comments are invalid: luo is not a kmod, and the write hooks are not set up
v3: add test case to liveupdate selftest
v4: split test case in separate follow-up patch
v5: add r-b tag, merge series with LIVEUPDATE_SESSION_GET_NAME ioctl
    as they both change the same unit test source file, to avoid merge conflicts
    add '__u32 reserved' to the UAPI struct
v6: add more test cases as suggested
    more verbose commit message
    fix docstring
v7: apply suggestion from review bot to stub out setattr ops,
    like it was done in 22bdf3d6581a
v8: add new patches to reject session names that are empty or too long
v9: fixes following review comments on LUO_SESSION_MAGIC
v10: split out LUO_SESSION_MAGIC patch as it is undergoing more discussions,
     and the other two patches are independent aside from adding test cases
     to the same unit test source file
v11: rebased on liveupdate/next
     reject LIVEUPDATE_SESSION_GET_NAME when 'reserved' is not zero

Luca Boccassi (4):
  liveupdate: reject LIVEUPDATE_IOCTL_CREATE_SESSION with invalid name length
  selftests/liveupdate: add test cases for LIVEUPDATE_IOCTL_CREATE_SESSION calls with invalid length
  liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
  selftests/liveupdate: add test cases for LIVEUPDATE_SESSION_GET_NAME

 include/uapi/linux/liveupdate.h               |  21 ++++
 kernel/liveupdate/luo_session.c               |  20 ++++
 .../testing/selftests/liveupdate/liveupdate.c | 113 ++++++++++++++++++
 3 files changed, 154 insertions(+)

-- 
2.47.3


