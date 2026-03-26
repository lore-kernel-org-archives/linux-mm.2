Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FC9210A88E0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 16:39:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68E9B6B008A; Thu, 26 Mar 2026 12:39:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640276B008C; Thu, 26 Mar 2026 12:39:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555A76B0092; Thu, 26 Mar 2026 12:39:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 43F7A6B008A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:39:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 709A9160DA5
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:39:47 +0000 (UTC)
X-FDA: 84588775614.20.A76FBE0
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id B834F80014
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:39:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MD+jotKO;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774543185; a=rsa-sha256;
	cv=none;
	b=neQnn7T2K36fiXxzbXPJNmqCeO6TtrBKFyaKkKxAH9SbARdx6XxCcRuxMo2IfyPHQ6ckBm
	q9V+HQiwuhrw0jNGGlc7Z7wIWIGW0HenYaEpGrsFEKojApuYIgi6i9Tuf0O0wijK7AOzOm
	4+uygnmuOFCKJXs+b8eeiZLJZqER0Ew=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774543185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5teIlBmpIM4CFlC0NlM94VBdqPnG93qpl7z+RCqm5g8=;
	b=Rm7ocDiPjDmCe8MArBENYBgfTgO6RALwMlgYzbQOmZU8IlHDrdqPUnMReQerVcsqs0+aKT
	cHW8RVt3INqL7dFqw8XIMqxU+IBlKtiNwS/2f7aoG2HI00RWz+I5b4Rmmo9g/VtGeQ/JT/
	2buut4ewAwO/lgVNt/TGC6NRjm35bi0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MD+jotKO;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5091d71aa11so13414571cf.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774543185; x=1775147985; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=5teIlBmpIM4CFlC0NlM94VBdqPnG93qpl7z+RCqm5g8=;
        b=MD+jotKOXpZJ7BxXXv4hG8yex6NaqCB7jJwX9/DI1RNWfqYi57QkcjNhFDU6+v+OpN
         yYzWzKTBqfuzDXrE6PBdRbGnvanNCTfZnyQbjr/6uBAL/qJNXz+H34mQFX8myWNDhBNx
         l+5lzrtFC8GmD2AuVEgYSv+WJZqh/V4l+OuMman/BNAifkJQCDsZD9Kv1cwtC3il0Oon
         IxdeLCocyNKsjMBMh+ZC9ah12snBdp4x3pH22PUZFgSo9oilBCftmdv0J+VbRjJGPVP7
         Dn0sDHygZRBT2UiRrOzYSSBW76PfpMLKLeKegWaZkgNClbX5a1nVWZ2eSwq+hzlr33I9
         LITg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774543185; x=1775147985;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5teIlBmpIM4CFlC0NlM94VBdqPnG93qpl7z+RCqm5g8=;
        b=WY550Ic+6BNz3iblwwKtmPlPtD4e/MkTAkRpViboxn1TTSYmMLWSf80GfCEV+fm1Kr
         a4eD618HbABEZfb5oDLSexIWxoTTo55Kdc3XtiYp/0nImvkA+wkTG2S82QQBGEVGmLhs
         gc62Q53PWGzefwqRn9tg02TmVicKaPsRbGFfCm4clC4OWmUb2e3S8HJDthNWDDIwnMUG
         IKKlA5oxZgPOAK4VtgJ5LXvfEwavBzbo+VvQi1aILlKSC8IDcQHQjOZXrlbD2+2slV3d
         elF7Jsi5h0lJq7j17jEyqHCtNGDXmvv4NjjX4kQZBQ/XwaIeDf20o0UEyKYDJXtC2r3I
         ee1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVKVJQ+A0ryT8zt2ZTpPkEL3jihl3VPjqz6WCLlroOeDhK5oNdB9WZhH6BihvxmIDNymz3YKo0UVQ==@kvack.org
X-Gm-Message-State: AOJu0Yx0pCJK9pGj9GuRPLWkiD0eH6ExuSkhhXs80FIgcLtj+Fb1aNnI
	buW3quBmKkqR14DziEdJ7dKW+NOKP1LL15wwmeFSC51u/4FNqdJFhoulxDGvYC9qyaI=
X-Gm-Gg: ATEYQzxIu12uhV69ZN+apO1j294PF5TkAA387woFBbaiyX+LvHinZ/7f2EomkMMDP2x
	G8KRecu2LzU2lPDbTMop1tih2HIsEgH/8DfjPm9t9dGm7hskncJ8Kj3IeiqyQwrHr2PTxAhqbup
	MVYKBSbeG9bmFYto+v68yrjvxVCV7WP3Ja2dCfla6V7o2eY5EU6jTf1OfyEc517IAnmDtyrWUiV
	mdDzA3YTBP2vOE1ENW+xkvIPnPyEI+Rv04cl+c68SxqIB9airuQVW42pmAszvZi3Q+QCuaN0vYJ
	0IJKjzQwT6GYGYV0TQdkUptLm0on7WCaZg/D0pNgLLJjNyFB70rjQLFJ/WprTWp4iDGarZMybAf
	FHSUteW3Zv8JzKufm00GZ1FxVRgZmwV98BYHasAhS3EvtwdFN0vxvSIkNKBB0U2LZ4TfCDL8Zwy
	sbJ2LiFiqFHdA/4Whzp0CB/uIu9VE6rHSFzSiaXXOz7icE3S7NN10kUZp5fLajZl2Z7NnwE+bld
	kJF
X-Received: by 2002:a05:622a:610:b0:509:f1e:41fb with SMTP id d75a77b69052e-50b9938d03emr25978071cf.6.1774543184726;
        Thu, 26 Mar 2026 09:39:44 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b920f77cfsm28238251cf.6.2026.03.26.09.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 09:39:44 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v4 0/3] liveupdate: prevent double preservation
Date: Thu, 26 Mar 2026 16:39:40 +0000
Message-ID: <20260326163943.574070-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B834F80014
X-Stat-Signature: mpwpmnemqf99gk18ynwqfyodpah5rkwo
X-HE-Tag: 1774543185-977892
X-HE-Meta: U2FsdGVkX19XJ337Qg9iSZn8lZOpOBjiCrodSFomMz4JOUX1giMpc9ZBmejw4bdRCjtqNmnr9qDSnCfyYthuVJt2c5vuTDnQELs9i2CKYLEafvDfOkEvQsIJ3BsDanzeOYdLopOLyvIPp5ZvbccpeLeMI/+K6oliRT4q1zxjaZPjlxIxV5E2jc9H8U4xhbkH1E391iuQ6QlTaR8aUB9I9SLPpE99oXmnse7iwu41RTbgB1ows/nt0Us5qia9qCu54L4PciDhYvqccIDNfpVtCjzF5rs6qA7a3IGodF9oFEEWvV78HFUoS10pqbrahVfSQWeLwhXk9NyqLhOUNEwnhkv+NTJ4OK6YfQcLz951B6rdypcba5JXEvFU+ztlxJOxifDbFUhhPeiwuiW0hesw02egCblFWwYK42ziaB96NkI0A5E1BbjljjtsW/xDLPKtgYslUBM0T9xo/mlLELWQ87L20oGcWURM5h0jRbzqAD+eFXLUtM1ZVhYMGEP+LgCAhPjdTPMsoDPKyzqyRt6G+bmA6Fxy1zAjnfJm49N5g63SG0B7hZkK2KOQ/h50MmKYUesCYyH2yBR6/Rgtz4zqzFw++ci99YKDdMjLS89+pe/h4y86AV1fv6g+twYubFgReGvNtoNAomk0SiSUAHOQ6Xrj/WXceH4nn1UobpCWeerqzpyYrDJxnDW3XLo2MShNidrrCtevzKZ/oOa8KTXkcJvSo3BXif496cw88pDrXM5pAimaW12KXOKCxY06xKzppUZqLMiRdg9MdVkYVlVmAbcFmG/P2BcOlbH8zuAMHVtHWQL0I6EG2tC5I1NPuysJ8h8CMGa1NWorsroOCgz8ihBXpPC2GS0riy4ti+nUW9v8nsA15fJwn84big1dKx4r8ZfTZyr5hVTujThPCyUV5G1epIXulSd9XjU2+KWRuOhhkc61PVypfa4ZxG9jFqVzXPKF02YAUaRAiziE9jA
 h12iyvba
 8Z9MHrS9zS3cz1VUqDEDGVMOi5/6GveLg+76oOggIpWw5D/jLI/CjpYz1ejWAvjVoYZDkMt8RmKGsN0Ls2NpeZpB5ee6SoBIiFqDE2chBQdmxwW84H+Krn9pq7tVw1oSyHTIIsOEbIHKusxqKORh1eXAD+dcGYfaBG7XK4WwTWBJhqLWHlRJ/5ZYKNfErqPIonqyI4tQsiqU+5tJvdGz5gZi/6L3gPK9i5hAlh0BsXSm2zCfv/6bVj5YDcfE0AWmv1Xj3h/bHEQ7OT4DjuVowilM/jaesE0ZkljNXnThZJ+eo3wCchlFqGFTveeq21Usq9mltB7LRt37h/Cl9JxLUZMUwKxfhFLFdIE5P/eQO/hph03o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, LUO does not prevent the same file from being managed twice
across different active sessions.

Because LUO preserves files of absolutely different types: memfd, and
upcoming vfiofd [1], iommufd [2], guestmefd (and possible kvmfd/cpufd).
There is no common private data or guarantee on how to prevent that the
same file is not preserved twice beside using inode or some slower and
expensive method like hashtables.

[1] https://lore.kernel.org/all/20260129212510.967611-1-dmatlack@google.com
[2] https://lore.kernel.org/all/20260203220948.2176157-1-skhawaja@google.com

Changelog:
v4:
 - Added get_id() callback to struct liveupdate_file_ops to allow handlers
   to define unique identification for files (e.g. via inode).
 - Implemented get_id() for memfd_luo to use the inode pointer.

Pasha Tatashin (3):
  liveupdate: prevent double management of files
  memfd: implement get_id for memfd_luo
  selftests: liveupdate: add test for double preservation

 include/linux/liveupdate.h                      |  2 ++
 kernel/liveupdate/luo_file.c                    | 32 ++++++++++++++++++++++++++++++--
 mm/memfd_luo.c                                  |  6 ++++++
 tools/testing/selftests/liveupdate/liveupdate.c | 41 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 79 insertions(+), 2 deletions(-)

Pasha Tatashin (3):
  liveupdate: prevent double management of files
  memfd: implement get_id for memfd_luo
  selftests: liveupdate: add test for double preservation

 include/linux/liveupdate.h                    |  2 +
 kernel/liveupdate/luo_file.c                  | 32 ++++++++++++++-
 mm/memfd_luo.c                                |  6 +++
 .../testing/selftests/liveupdate/liveupdate.c | 41 +++++++++++++++++++
 4 files changed, 79 insertions(+), 2 deletions(-)


base-commit: 0138af2472dfdef0d56fc4697416eaa0ff2589bd
-- 
2.43.0


