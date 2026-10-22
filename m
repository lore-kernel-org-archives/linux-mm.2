Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D2A960A2611
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 01:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=JhI+7PZW
Received: by kanga.kvack.org (Postfix)
	id 6D28F6B082D; Wed, 21 Oct 2026 21:58:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9516B082E; Wed, 21 Oct 2026 21:58:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C0DF6B082F; Wed, 21 Oct 2026 21:58:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C65F6B082D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:58:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B20AB1A0674
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:58:50 +0000 (UTC)
X-FDA: 85348603620.22.F364757
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0969F100005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:58:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JhI+7PZW;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792634329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HijCuOpDuAK6PXX4hhiO509M0K5rwPq4Jmik4wLwBWg=;
	b=8O+2EpjyN63VHEK3CL4RVrNivOGZYb5sMOXxPJfCmQLVKPgwVPviiJQhgPKHCa3rrhblmx
	QiJfeHNFIDeTmmx46Qjw71DBJOdT+VysAe3/z6tQqGDyo/8WH7NGG5f+AX6mTetY5Tzuh1
	HOfOKhAfIFZ7ApQxVU32AB9xjCwqn+8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JhI+7PZW;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792634329;
	b=Jvv90OEftTqV6rr4T0WMeJ1l+w26tJUh/HS5WkucdfHieexBsoKEZhCj954z+Z6suhcZ5D
	yDFNmUUD3tfaBf9EEzCDJOkwyWZoh9bEWgKqxe4H/R4MjATAjnt5zB1SySp+qDRoU+rdbI
	ggFZF7tiVp2t+h+IiNcLW0JGVte/Rls=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93f22a8515eso124781785a.2
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792634328; x=1793239128; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HijCuOpDuAK6PXX4hhiO509M0K5rwPq4Jmik4wLwBWg=;
        b=JhI+7PZW45dZ0ZTnrW9fBMKOFfk1uDQIg3wNTGeeQZLklEL+lYhRFBoBzPj0+3fliu
         Cvzz5H+iO/dQ81ZFsnxkJu33GUlWff37yAav+cownC22OOnN2iYr1ShfESNPdo+OLcER
         WQLi+AJtZ6u5UKezW29Nf5x/otiAxdNRasIEnQ6crCG21nkArGvzzlQJFNKGj5pipNgj
         zASgUdcgrCf2GXHZycA5ja3KqXdpv0cs7F3if7kZIakPm6okEa6eLpclgnkrdVWcEe8T
         Hz4ic3hsok8/T7CjwEhA+F560Kig6rfBu3B3zYQpK5ME0zfQmSnG3WMmPhgv8hrBp1kL
         jyoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792634328; x=1793239128;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HijCuOpDuAK6PXX4hhiO509M0K5rwPq4Jmik4wLwBWg=;
        b=mdq+YGj/w+sW9ssX4Dh9MzEiWy1YU1O2ZfggxyAXrjtcnQdpHDzE7IRa90QELwSWFQ
         lN7JEhW1Q+x8UQsAyP6pLuhTJ6Vwx4riUQIdAJR70KvZA4pBhP1/rXZD6xHOWTye4f+V
         2Y6UnoFM23OQPv3tmN+75w3XWf2+glSlzvij3nWSvfnHTvlSKfsyyHgdujZnpEhf5+oP
         RoIyvVddAvveK2ovJSbZujgkIcSfHNhl0OwzE+TXHq5vb/zbeZVvcZXSa2JoxubOUfLV
         oVrnTjkqEynoZVG6guPoD7956NSC9iHc5SEbDLWPRslnmQEucjuul8cFNKtk7vqkFgtU
         WSMQ==
X-Forwarded-Encrypted: i=1; AKwUvBznN+fSIcJ9EQZrZZYADInA6haPMb0VWr2vr2Z+K5HK/KWqb7P62vr9McxTdmfeQQOqsQw3HwFp+Q==@kvack.org
X-Gm-Message-State: AFq9FYJhH4G1wVkaCjmMwNaai0AnLjkk7RP32VvdFh1cYJoYl6Cv0/oe
	UO20M7oRg/pOR7EpgqNhJ2Gbj9yNtLbpLkWKEzFeJa3Z86EmwlJnp5CZhT5/alAqYB0=
X-Gm-Gg: AYBFou1yKYmW0GBsBG5BQrqAAJ4EONlfM6DNojZqkhu8H+BKfGEiLrL6w/GRc4PXlT1
	3h1mFU9RL/akinNfrbmi7p+SKywPL6MuZaYj5ITdXr6L2JKyrx887+tsXUwhIvtKx5+CtlYbNkk
	LDltgrUsg/DrAI9j4/qx2J+SLz6ucENXhcLWumlU2lwiR2d4FpWLp0HYGH/IO9FoTK0MD5NNdFl
	k1W5Cm6gGwwgeABj5TDwWhg8yiEhHWUcwa0A12PVMNNs4dYHNipKivyEkyyea/4hHg8DgYFaIvn
	LXKhBBC0wRKriz1CGStUeV55kYkRKbc7V8llug1mqPGK9qt/991V/5O+dP9SU9fEKoni1DQ7gHV
	AJa8n6nDpK/lYT74eAz0HC+IT+TnvZ14Bhc3sFT/9uURFla08YE/JKCQJVV+9E0K6uoUA10cjjS
	zZn9AOtwpzLkX5UzwCYaHmAWIEI0L5iU6c+w0uXFc2e9LcH88bG93AUOJKcNmyfhZc31EFzjTR5
	wzZxWyOLZQpzDLWKmEYboKOF6m+WN1J27m5BgFKSIEjvAZ2ibeaQOG2OQwyIR9ZMz4LFQMEXQgZ
	m3pwc7LLc/WNcdCb2hIJwZCFhCzI/rdb7J1WeUUTJf1IfhrR+pEcX6T9fB/YPKGrIf9VpfESVSF
	w
X-Received: by 2002:a05:620a:2989:b0:93e:e4d1:797b with SMTP id af79cd13be357-93f57fac2a1mr783266085a.56.1792634327158;
        Wed, 21 Oct 2026 18:58:47 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56e247ffsm397383285a.39.2026.10.21.18.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 18:58:46 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [PATCH v3 0/2] liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl
Date: Wed, 21 Oct 2026 21:58:38 -0400
Message-ID: <20261022015844.2795816-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0969F100005
X-Stat-Signature: tynip4rx7gm4pwqbethrh519bnmnnczr
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792634328-907226
X-HE-Meta: U2FsdGVkX19gWAYjghZPnniEWBQxhjoiFD0o+h+rXl4HCbHIL/jBoEbpv3WMgBCpV4BYR/+uJuk/7JEpz1OsOPa85iwBhyuFALFELiRFN5D1AwZB+qoDbHRDQ1FF3ZNhs1WZhngsOIwihp4Au7/nqC2OyK3nTRo9XeOVRjmJzqGxtiefkkC2BoE20ixofK7/Kat1uGQkeCExfGO1sZo2ApUu0SBRrNNYbQfCgSf7yvrrxLKZhKt/lEDebrW0Vjx6v0f9PKzXTuDBOAH9PkucW0k9l9/Z6k2NSx3XxxQAKZly61N5im/TKFvYrHfno1SvYhMtSjEyZvbU0wyo1T66vUOHElCS70u9uD/1BF9Ic52E/w8S4ZysxfgyqjlqtBdfUkybOdW953Fu46bH7JRTOaOuE+YayGPYuZ7Uvwe0qZOv0PClFf8+dxmD/8biZWlIgUI2qvReZSUROA6ZoJ+R2guHteCf9Myv9c6i2upc8Gqn7sw42enEaZiMCxXSTlAS1Jv49njU8Sc7eTDaeLMjPXCb3rediJ/i9NPKu4LDbSOq3qCfNIgFChwTDtHksTM2IcHbAyIQKUyhdhuEDIMLBcGR+dNfmKrQHx7kw8w1k5ID82cLYsuLEtBhNyalIT4Io8XQP/CGPrWxcCc4SYhXcTKlfV956YAtzqd90JctzLG+uYHwASMBKtCBZNUWbe67KWDm08bkBFZhIYDO/w2m4c7x5rDYrdEnDnfES9lgNAEMIT8wv1UAnah4Gasc2Xyf7lg0p+HzrKmQfus0WPbvOznHqPYOm7Is5v92M/1/ZnyzMeQPX9Ck5cP9loYYk4Y/FsRW3VeDnsOQ7Qe25vH7ZEPk+HeuTvogR0PBVBJEh64rcw92GXAcZ8c/OM7zBGKOt2EB3VUZZ5Orkas247Ce3PhscWAIBAdkbbhxSiRD286YPnd/TUEHrrLb4XPZBEki/2Hdi/ZbehSlqM0YZR5
 gRL+mDLW
 9yWh3LkpliHwlsXIKSYt/w3JTeEnElDEefSkGAjQ07vkBLdCgrHi7aGwqKjyH/ncFrwp0tqbhFYRuCnm0rvOYaXXh/XEvj4pfE7iI9zIq7FpgLRDwvVRadizpAq9wnRaWL0tVVRpzYE60/xEo5Jxr0QtJ1cnsKrMyNRVUJEsYeuwHFoBY8nOY37aVrpNRx6hBOigPfBFxPqlDeOmW6dSB6OTzuXqYb7RJDIt2LWcya4gL0ZVvPz++d4GxIyKcRxo8I0FP5iVBG1i62Fy60A+bx/MeDAeRvEBVIMK3xeVoJD2xq+Q8tkdvStvwquAmA81khqh/B/yyJOh+L7WzEoJoR7C98n/s/0aOmC21Q4ZWyUtQsyW1RqGTQpltevQwLszb7pbDzh+p58zgXcO4Lo15TNbA7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, LUO sessions are frozen automatically only inside the
reboot(LINUX_REBOOT_CMD_KEXEC) path, where luo_session_serialize()
iterates through all outgoing sessions under global write locks and
freezes them serially during shutdown.

This series introduces the LIVEUPDATE_SESSION_FREEZE ioctl on session
file descriptors so userspace can freeze a session as soon as it is done
with it, rather than delaying until auto-freeze at kexec time. Because
luo_session_freeze() only acquires the per-session mutex, userspace can
also freeze multiple sessions concurrently in advance, reducing kexec
blackout time.

Once frozen, no further files can be preserved in the session and
subsequent freeze attempts return -EBUSY (or -EINVAL on incoming
sessions). During kexec, already-frozen sessions skip the late
auto-freeze step; if an early-frozen session is closed before kexec, its
files are rolled back via .unfreeze() before being unpreserved.

This series is based on liveupdate/next commit 27be83a12b24 ("Merge
branch 'lu-pci-preservation' into next").

Changelog:
v3:
- Renamed session->frozen to session->user_frozen, - Pratyush
- Added Reviewed-by's
v2:
- Rebased onto liveupdate/next (commit 27be83a12b24 ("Merge branch
  'lu-pci-preservation' into next")) and split out early session freeze
  into a standalone series (tmpfs preservation and its per-file user
  argument plumbing were spun out into a separate series).
- Patch 1:
  - Drop struct luo_file_set_ser * from luo_file_freeze() and
    luo_file_unfreeze(), and rename the session helpers to
    luo_session_serialize_one() / luo_session_unserialize_one() so all
    of struct luo_session_ser is populated and cleared in one place
    (Suggested by Pratyush Yadav).
  - Unfreeze the session's files if luo_ucmd_respond() fails in
    luo_session_freeze().
  - Update remaining reboot-only wording in luo_file.c kernel-doc
    comments.
- Patch 2:
  - Add checks verifying that non-zero reserved bits and freezing an
    incoming post-kexec session fail with -EINVAL.
Link: https://lore.kernel.org/all/20261015093816.2438942-1-pasha.tatashin@soleen.com/ # v1

Pasha Tatashin (2):
  liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl to freeze sessions
    early
  selftests: liveupdate: Add tests for LIVEUPDATE_SESSION_FREEZE

 include/linux/liveupdate.h                    |  3 +-
 include/uapi/linux/liveupdate.h               | 25 ++++++
 kernel/liveupdate/luo_file.c                  | 73 +++++++---------
 kernel/liveupdate/luo_internal.h              |  9 +-
 kernel/liveupdate/luo_session.c               | 87 +++++++++++++++----
 mm/memfd_luo.c                                |  5 +-
 .../liveupdate/lib/include/libliveupdate.h    |  1 +
 .../selftests/liveupdate/lib/lu_utils.c       | 10 +++
 .../testing/selftests/liveupdate/liveupdate.c | 49 +++++++++++
 .../selftests/liveupdate/luo_kexec_simple.c   |  8 ++
 10 files changed, 207 insertions(+), 63 deletions(-)

-- 
2.56.0.218.g1ec904b173-goog


