Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A221EFCD99
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12FDF6B0089; Mon,  9 Mar 2026 07:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A9E6B008A; Mon,  9 Mar 2026 07:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E230C6B008C; Mon,  9 Mar 2026 07:08:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE5C56B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:08:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9AD01160149
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:08:11 +0000 (UTC)
X-FDA: 84526250382.09.A40F397
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id E635040004
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:08:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PfDcmu9F
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773054490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ou/KDlwhCrMpQjDEptPGOK8uW6VutdEwWpa/tFq6f5E=;
	b=NssMIpLpVNeTuia0RlBnyF2GwGmycCHIff9kOT2+CZeDNUOxvFbiJ2q8fmG/TT1oV3d79R
	+ZRUs7HY8/EUqnuhSE9ZAQENzXahoxvnYIGbaiyScoqZEmqv0OORL0XphW6mVS5NsM9Qmu
	wcVLyBJaPjuYHsmun404GSRSTLGGJFo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773054490; a=rsa-sha256;
	cv=none;
	b=6hwZPNJC2TD9SJqz5i0rb9VzQTfenUjWfhkq0Hlsj6Kecy6CbSob92I/WDP0Kh+C/vFI+Y
	2zuHjw16ghqd9tlnU/Ibica/OnJO4c0pDcospnTNkWeSyl+2lBUe1ZZ+qb8dYCROaAEuza
	YAMao8SB1AYtPHV7UDvZlLuPrzetsBU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PfDcmu9F;
	spf=none (imf12.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ou/KDlwhCrMpQjDEptPGOK8uW6VutdEwWpa/tFq6f5E=; b=PfDcmu9F2EykdnY+hz5+0mRGEa
	59pLWvWrQoFNvme2RtwtXBFU5UpIkvcoh50h7vDwydTLVdxwoxOgdjCv/cBMO3yhvkgBC/XCjp4ip
	VTIe8JrK9tYbtgG0m+Yt0Hyij/ft1P0Biy+j830WPE2+bUVKSPDCqsRTlqMuhj+vi2HLjHz9S4d1p
	9QsokVzqw9bIWcOdUgTrKNd8AA/8PFArMv5TV8jnYf1f76c6f357mKrkB1FxiK3AK6Q5ChS1S07JV
	vRLKROetNCtZ0sKoSGS3m1IibkCpkYfibLzhgfOuh6QiEyGV0kQ9Vt6QPVIsI7X+D+jfzwXBHswB/
	zVtKLk+A==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vzYSj-002AwE-Mp; Mon, 09 Mar 2026 11:07:51 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v4 0/4] mm: thp: reduce unnecessary start_stop_khugepaged()
 calls
Date: Mon, 09 Mar 2026 04:07:29 -0700
Message-Id: <20260309-thp_logs-v4-0-926b9840083e@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPKprmkC/2XN0QqCMBTG8VcZ57oTx82tzaveIyKmm7oIlc2kC
 N89LCKjywPf738ekHwMPkHBHhD9FFLoOyhYvmFQtbZrPAYHBQNOXJEggWM7nC59k5CkcarUVCu
 nYMNgiL4Ot1fqcHzf6VqefTUuflm0IY19vL9+Tdmy+2Tzb3bKkFAaEppn2nIp9s6XwXbbPjawd
 Ce+lnIlORIaVQrrdkZqk/9JsZa7lRRIaHPpeKVrobT8kfM8PwEdklB7JwEAAA==
X-Change-ID: 20260303-thp_logs-059d6b80f6d6
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=3022; i=leitao@debian.org;
 h=from:subject:message-id; bh=Sz//X+ELvgH9H2Tn8iGH/UtjsEXnM3GKlao1x/tSagk=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBprqn+k6CfimEitPfaFsAEfK8RMt8SrvI+gzISB
 iN1t5c3rMSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaa6p/gAKCRA1o5Of/Hh3
 bXj7D/9xhWzHrXCQdosMHtoIUYjk4ZirKVB9c0l4FHZ5nb6j5ZNerk8ZO/s7j4mfCfewCRXnxw8
 fL0AOuHjeUzW1dgYFWuJmwU2DkpJxVrb9CapmQNY9nGxnIsHSLDUIhTTvHda8ea1gjiYlyFn6p+
 D2IE2SfmjMSlw1CGfew7tm0RMiqxFoBax2EDrK1hfywYUGg8qhyI4cHI26Eyup3svMsbx/9Gg4V
 1P5FNqAOoXecVRILPB1q98UzDm5qClPqK9EmL++WE82x4+xAYv5+LGqUiaKbMINDeFZXjNPY+DW
 wiW6QZ2kUcCFuKa444J5B9oXEYU9xrFHp4DUrGWhM1JrUoDtPhNf9qRuwsf3Ptd/co299g4dEfT
 GYIkLqjqzgsCgb+HcMo1D4+G/9D6xx/dQpw5Bx7QevBs0nUGtVTXRm237JfWt7MxhcG+UzW8K3n
 T46OaWxuhQdttZXMHrbvs9bo2g9+tFCkZMs7R/TOrh7+cKCENwjKSlPQrYOT9yEqdV2AzzI/daP
 nJhcqsEl+PFzNrOwYJRGBt8Rjc807EHy6knj0VyGr04k2sYRgLsg1STgEM6/bX27LNZa6n7rK3a
 KTXKZqsxTI3swA2dKTQrQKlO1Ne1grRJ82SG+wuL913CaYDa7cH5b0H9PcFkqW+GvTMyZ8q2DpW
 E7jS2PgVdsvB+mA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: ofpwb3ue4kkoxq7aask9dnazobgwtzxo
X-Rspam-User: 
X-Rspamd-Queue-Id: E635040004
X-Rspamd-Server: rspam12
X-HE-Tag: 1773054489-316767
X-HE-Meta: U2FsdGVkX182ff7zj4mFL4XhjiDIfA1ppu5J9x/AhHZDa2RG3ynf/g0qspb17D3Sjxa2E30NsT/6qv44n/cLpD16rFPc5LxXDSQXQjilWgjaTXF7ZnNedqr85ABsKjcUnrljMNJNXKnVKNMDaG0TsAVHQ/inR7nJ5UWd2ayqz/C6xxeG5LO726MsdV033poBUoKNullqOfm7PAN3ZCvYZjsRAH6f/nbkEGAkjroKoucGe+rkr4j2JiUoXm5WJK1Xj5vp41SL/m1AWvzwj/g6idmklPBA8XyJCRJcIRE9wqF7K+I6A5oMRGVVSMWlC4WiOPPbja4wU1KNg3DXJuIiiZvTatR+sMZhBQbCI6DpqUG0ajmdhh4VXD8abBhFsLDD5cUwN1OfCEzKbcZCdnffYnD2YQ9jvPP8RPPqwky9RKoKH/PmJP4A2uWIfpCPw2h+6UhBjyPfOtHeM+h/mY8VHmbqvEEEOlD14ys2jKpkzHFbtiCe91h2PXqZsYUEW2+AjlYXwW3Ym/xX43w/tv6XvFuIbeee+v82effBU8IZZ6XZJCeYsX1pk4O93v5rQl9tnF9/GM0bPT0eTxTK2chGhvbbBcunMeVzT4K2LPVTv6SOKDHCJjloh4+XqwGy3MEh0wYFiGIAAw/a7MiuG2hHZ9LEFJ4pJUUwJdZMs6B6cdOAUUmEcfQL9PPyNmX2Nl//mel/qS17lcPVQ0arIknYEg/pGL8n2vGvt3ZmuzUE4JVbRUpqtVv3Mrptvw9M7ABlT6fjJwMeAqdLtNQsEejw/tgn1m/MjRK21aavDiPSEuMV5MG+yeVMAHeugkWZXAqCHVykFpkCKft5wevntf+NS3Uye2AlaYmYa2VP6ESV3xA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Writing to /sys/kernel/mm/transparent_hugepage/enabled causes
start_stop_khugepaged() called independent of any change.
start_stop_khugepaged() SPAMs the printk ring buffer overflow with the
exact same message, even when nothing changes.

For instance, if you have a custom vm.min_free_kbytes, just touching
/sys/kernel/mm/transparent_hugepage/enabled causes a printk message.
Example:

      # sysctl -w vm.min_free_kbytes=112382
      # for i in $(seq 100); do echo never > /sys/kernel/mm/transparent_hugepage/enabled ; done

and you have 100 WARN messages like the following, which is pretty dull:

      khugepaged: min_free_kbytes is not updated to 112381 because user defined value 112382 is preferred

A similar message shows up when setting thp to "always":

      # for i in $(seq 100); do
      #       echo 1024 > /proc/sys/vm/min_free_kbytes
      #       echo always > /sys/kernel/mm/transparent_hugepage/enabled
      # done

And then, we have 100 messages like:

      khugepaged: raising min_free_kbytes from 1024 to 67584 to help transparent hugepage allocations

This is more common when you have a configuration management system that
writes the THP configuration without an extra read, assuming that
nothing will happen if there is no change in the configuration, but it
prints these annoying messages.

For instance, at Meta's fleet, ~10K servers were producing 3.5M of
these messages per day.

Fix this by making the sysfs _store helpers easier to digest and
ratelimiting the message.

This version is heavily based on Lorenzo's suggestion on V1.

---
Changes in v4:
- Use the enum instead of int in the new functions (akpm).
- Explicitly initialize the enum values (akpm).
- Link to v3: https://patch.msgid.link/20260307-thp_logs-v3-0-a45d2c8f3685@debian.org

Changes in v3:
- Extra ratelimit patch.
- Create two enums, one for anon and one for global. (Lorenzo)
- Remove the `extern` from set_recommended_min_free_kbytes (Lorenzo)
- Export set_recommended_min_free_kbytes() definition to mm/internal.h
  (Lorenzo)
- Link to v2: https://patch.msgid.link/20260305-thp_logs-v2-0-96b3ad795894@debian.org

Changes in v2:
- V2 is heavily based on Lorenzo and Kiryl feedback on v1.
- Link to v1: https://patch.msgid.link/20260304-thp_logs-v1-0-59038218a253@debian.org

---
Breno Leitao (4):
      mm: khugepaged: export set_recommended_min_free_kbytes()
      mm: huge_memory: refactor anon_enabled_store() with change_anon_orders()
      mm: huge_memory: refactor enabled_store() with change_enabled()
      mm: ratelimit min_free_kbytes adjustment messages

 mm/huge_memory.c | 147 +++++++++++++++++++++++++++++++++++++------------------
 mm/internal.h    |   5 ++
 mm/khugepaged.c  |   6 +--
 mm/page_alloc.c  |   4 +-
 4 files changed, 110 insertions(+), 52 deletions(-)
---
base-commit: 9dd5012f78d699f7a6051583dc53adeb401e28f0
change-id: 20260303-thp_logs-059d6b80f6d6

Best regards,
--  
Breno Leitao <leitao@debian.org>


