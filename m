Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD40AC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 22:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B65446B0088; Fri,  4 Sep 2026 18:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15F06B008A; Fri,  4 Sep 2026 18:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2BAE6B008C; Fri,  4 Sep 2026 18:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 83FCF6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:06:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F18BCC014C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:06:00 +0000 (UTC)
X-FDA: 85177463280.28.73830CE
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5C02D80005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:05:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=huk7KqyE;
	spf=pass (imf02.hostedemail.com: domain of 3xUCbaggKCBA80xqCqzqw44w1u.s421y3AD-220Bqs0.47w@flex--skhawaja.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3xUCbaggKCBA80xqCqzqw44w1u.s421y3AD-220Bqs0.47w@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788559559;
	b=naUyYUOXJY92nb35VRWvqCMOEqq9tL3Z+mpIjCCOVjyqRK5n0a/dymlKgzTC8AdnVsOH/5
	0yFb1RQvnQ7Sf5o7cV25VYZdaDeVFSiYbZJmu98j2a1pudK9u2dzvsJGp6fQrt9H+XyPgz
	EDg2yMaVhQNVdCTlOIXbL9/Plu01UZE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=huk7KqyE;
	spf=pass (imf02.hostedemail.com: domain of 3xUCbaggKCBA80xqCqzqw44w1u.s421y3AD-220Bqs0.47w@flex--skhawaja.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3xUCbaggKCBA80xqCqzqw44w1u.s421y3AD-220Bqs0.47w@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788559559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Xi0GrjNtf+j3mFnPowGAqEQrMP8mYt8469qIGDpsVtE=;
	b=pM3RAXORUKYv4xOswGOhWEECZOUvCG0JJPxKRDbxgca09ooeMh3HvYdCSOS8YOVd+YHeXt
	PDQtSaNINBwqiIDUaUhm8aREpvUgU7sV9f48ufWBCthjr8K7wn+cTrdzWtJFF7k7UfmpsF
	HmBkMV9ilBBOCku1/vdUOdcBeXnIQOc=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc2229450b4so1503861a12.1
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 15:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788559558; x=1789164358; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xi0GrjNtf+j3mFnPowGAqEQrMP8mYt8469qIGDpsVtE=;
        b=huk7KqyEOSfAYNO+U7jJqf9tFMFMt0uQY5S7HsFjc33la/k0JpobR5E6pPj6IqaaeZ
         s6sgvQS95zHcYVPGIEvwzb9ObIcM+tf5uZDLrUgiMGhJoJqrGGsu0/49IWV4wlHpRQBx
         Rl3Xb4ro0gO3CI9xU7RQf98gJNMNP9VmOB759/7o8XFPauZOFlZKW3E6hGeA1uCmLOYq
         CTTypQeSDMSSq2Era7p97NLZ+VD/bz7dI1hzXnlcaUdcyu+/DsTgCpAjLRJZyya0nvMh
         +2s2+7ZvRbEfD3r/emeh0YX6ciCDVYMm/I7UewcoGmsLTcs7Jgk5rKsicoXwxRb06lRq
         2bAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788559558; x=1789164358;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xi0GrjNtf+j3mFnPowGAqEQrMP8mYt8469qIGDpsVtE=;
        b=BfrdnvQLIKy8qQAL5hTOBgearXm7ypymvXjPdBSBY0ha1IemXsso7S/ocZzIyUh82h
         hlcXni+s5wzi7uolg5AzvD5MXA6Uo1UmNinHZOgg0oMDYYz72bSd1OK/SUFwCVLAFv2g
         dnQp18EUJV/HY2ytFg6rLEYwvX5Wb3Hqjx/5rhGlllDJSHa9+qpLqZNfWx+jsoS0jqYY
         V4ahJ4YLkcsL+F9NJpEANyX0tIqI3fzEXLZ9Ta+1QOGQ1lO+AtlKla2QDiE4885vGGF1
         yaMiX+90qNbUTTpc0u9mS9mApdmRcdmJmP86zoZXgF+gW91iHFYjcNGEg83c8X7coB7Z
         EWYw==
X-Forwarded-Encrypted: i=1; AKwUvBwU/FZJ6Ku/TKEQlJIUE0T5S5jghc+wuGF0V908tLlS/tZ2Sx0KFCKQXG4XVjtm1n+HqXRftiSKLg==@kvack.org
X-Gm-Message-State: AFuF++nD3dmgwOAF9pFwUXB2ym6VIKoRNzosNfd7v4O1q206+jaNpZBy
	radCn2Ip2YMXDcEO7sXupur9rFglD48tB4DmBRt4rn4Qii2EohqCeXWGonfhu64rsnZJq/oRfnP
	Or058e5898oPsuA==
X-Received: from pfdr13.prod.google.com ([2002:aa7:8b8d:0:b0:85f:2b12:262a])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3021:b0:857:727c:a1f3 with SMTP id d2e1a72fcca58-8616907fefamr12452673b3a.21.1788559557820;
 Fri, 04 Sep 2026 15:05:57 -0700 (PDT)
Date: Fri,  4 Sep 2026 22:05:53 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1003.g10538fe699-goog
Message-ID: <20260904220555.589752-1-skhawaja@google.com>
Subject: [PATCH 0/1] liveupdate: Add documentation for file dependencies
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 4nynry9ncuz3stxcymoqnjzz4zapkuw8
X-Rspamd-Queue-Id: 5C02D80005
X-Rspamd-Server: rspam06
X-HE-Tag: 1788559559-791922
X-HE-Meta: U2FsdGVkX1/F26mWT1qzLRt7zWtAFopIr+6D2Ij+ZpQvDvoYcsxb5QtqY7w2USVR4t/3Oy3wg+JZZmfuJblyX0XbZ0xra9B0nRIxweuGJGY7SzDbtqI1nRsshrMD4YUqKgOMU/JTIyCQKWaoKvN2whJ4ieAOWPI1Bg7ziosEPaceqjE3RZy4u4g1dIBZG9SDb3QFVdwxb5quEeDlOiU8l+nlf7nnzuE8wWmxVyzROW3rBztZxvl4Pyr/JY3f2G7f+mxWi96TzhgMRaaYVwCiAkPDeevGMikhT7cypeMuSRV1bO4fdxKiPP3ck8/MrEEUqkvZttipq5MWdrUgAlOmcOKXYo3WQHImKE9Q2Yjn3tmNGC9ETUqm0LxjxTD//B/4HydvkNWBaOk3KZQOqEmy1FSw1/eyig3qiT9DMbJwWYOcSCawJDzPfQBSZ1+iQXdf/1VDsZqv0HOUZ6uP/AgFRZFFB8SOqsSMlNWNU1WeisQ/8l2vOs2GVeR4QlAs1wQMdTI7sAjTq9K52TTY2TMGJ6iip1+phSj80THsuC1RDxFiWkBiJJvgDFzLBmTucofHNmAkwEMc/pxG0UDmTu4Oy6hqM1yk5MUbzIog24evpAIgX6oRPQjYUhLDUMLCuzLDKNDudDCOt73fydxQ99YD3Jfun6nzEc0OEUlcAGM14Lfy3J7eOfcOFYrnaa+hG8e5yAcwVMga0Vi2MnqrGqdT55aoA0CajvL5y1DTSsfWE5FX5zxTlc9vCuxYDBytC2meNi0wweuGLiFpTo6V1uKjNv+M/pqp8xaEiD9Lr7DIDoPlTN0qMGTgaKkymQqIVvBEHU4wTQY08ULT81EQwLyHDlOOA2STFr/FO3epvGpYoBlLME6LcOoBRP0WH3XMKFNyQY4ZhUYHqrSV0lSihzOY8sJ6r2NO/MdmNCEeEh5UstKvZk8MEl0GmULEQdOW4JxqC4CksgpeyaPTHzjWTGo
 NhzbXTmM
 W52lsJY7RKSrWiLJfl7VlFaqzQzRUhYPTySoVjw8Ywr1bzpFCUjmTNvrySVyMaL7zM1Dx4ZuOGVCjroBVmlW6LhULCNymSLQY4AWRMymMdVx/DOfB1Xs7ZTK2EE1JO09AqB3r/7DtO5UVdACmbgRwuwoKVxAgpfcWGP+YbRxYOW7b4hgVawjNbsDYqfI8rL5+Plkpy3zU96ien7/KQed7TePMhXmMgzETA9vLHaQl4BCjTN6Nj/ejy9WHYhvcM0c9c+QDRQep+TVP1Y6p9nrSGy0yDhyFyPTCxmEz61uZGzl53Jp0a69WA7G/O5ofaw02PoLLp3Et2VPHoC+Gcw7VUkRRYtL5u7zu5/9yXSxdFzq+MDHlul8TSL1lqiqfxv1Xa82W+oEaBLVCYgDM1ZIU01dMpaMsBRsTv6rqv24cqeenjCnq+hdaAIlOq3PEDZXDr1EWoklAWtU2SWjZVLPMIjPgZDkAGbAhX+i9m9I0ImRvc1fjFCxjsiUmYiPele2PcvIv4NA2OqLdfCVqsDutnbAtGdGAD4EJKlE+dbReqj6CcbtCmxJ7BrRERTN3ajLp+zZVlKWd7TzLugDzcZOY8lGWNNN12Pw81ZxcZfXwZOmX5Yc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I sent out v3 of liveupdate_get_file_incoming() and
liveupdate_get_token_outgoing() series to add documentation for
dependencies.

https://lore.kernel.org/all/20260820191854.1642931-1-skhawaja@google.com/

But since v2 of that series is already merged into kho/next, I am
sending the documentation as a separate patch.

Samiullah Khawaja (1):
  liveupdate: luo_file: Add documentation for dependencies

 kernel/liveupdate/luo_file.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)


base-commit: c65687600ed075d237a204755d99ad538db34b47
-- 
2.55.0.1003.g10538fe699-goog


