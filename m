Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08858EFCD9C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:54:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DACF6B0088; Mon,  9 Mar 2026 07:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3913C6B0089; Mon,  9 Mar 2026 07:54:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BAC46B008A; Mon,  9 Mar 2026 07:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 197326B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:54:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B3570B5E3C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:54:53 +0000 (UTC)
X-FDA: 84526368066.03.94588B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3013FA0004
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:54:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sSk3ziS2;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773057292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Vrr6V+CEdPSiChOSnrq0ldOuSpE0DMdIeBbb3cdH25o=;
	b=42I7cTVOLnqK2VuVXf37kZRM7NOC2TkQfFX7raSK4Kg5+vXpUnUm2hPIRs88221ubGsjsx
	6Y41yCdt3/SqxIwT+yxU+Z20ur4DuGg/8HbyJ4d8GnUboPEz97NaR/zrb+hxbr9CfxVucL
	wFswZT5znXILzVHZyEL9y8qQJGqjYrI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773057292; a=rsa-sha256;
	cv=none;
	b=e+FaOpd0OKo/T77HJVpZ+ZGZR6+AEJZTchixIlThdOlSpIKw3uFu+DwRJIRrIqeoBpP8jt
	6mvWRuw4zaZFsq4SaDZkrEs+0h+EboeBupNSI1kNm+wtpw9HZxaVmP1jQq+eFgF79iECP1
	I1fTE0gsAZNQ0Dc4yojRHaFpVab7zrg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sSk3ziS2;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 34A9743699;
	Mon,  9 Mar 2026 11:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC4FC4CEF7;
	Mon,  9 Mar 2026 11:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773057291;
	bh=Ddb+El3YDgPpuwIWODCSXmi4I1hpKgUou8IoTA7aR0Q=;
	h=From:To:Cc:Subject:Date:From;
	b=sSk3ziS26djj8bwpKG0AaOZ7yAiinOp1WrjYXqDKQNwujipdA2xP8J3TbIRUoKQtZ
	 ju4hZeEPLmNnjWHBTXlef2+vWJlp+KLFvRyHJ464pcL38vZiG8I6TZeRp40CTzEnHX
	 /gzRcoNO8WuhPh7s/zOfIkFL7s94Rfjz4dWSAHDPAtooY5SXe6zkrTG1Lfyeh9V5N3
	 rN62j3cRqIgehyd4cF/XtjD3zhwMpN+/zjSOQ4v8Biadu0/h9ZYSB9TOJDEs6ByaF6
	 SIx7+NZmlR43vPW70gyVmzt0H7DA5BSZkrLfEP5iVoHE0bTucLUX2dF6aVVx7J50n4
	 2LtiBvWDj4r4g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/6] selftests/liveupdate: add memfd tests
Date: Mon,  9 Mar 2026 11:54:33 +0000
Message-ID: <20260309115441.266805-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4edgxbmwc36bsp8f5hqntrij9pdg9y9r
X-Rspamd-Queue-Id: 3013FA0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1773057292-387264
X-HE-Meta: U2FsdGVkX1+uUBV6TeNyJvVupQTo538c5PjEWoEqtfB8LcO+pBmm9UIS8gZJ0zojJinp64UkihIxWlHXtYgs4+ymEQC3LGCM/eRagdPhPTKYR2VLG5TXSTVqHVPLpyL7amyYTyLxGq5CX8sciuG4j/2n5xlzM18S2Euw7U/4wlnx98hhbhylKrDhB8jIjMHAyCd3J5DRUriBkMOzRHF0YPxrdLjJ5WMPzeXs7tStp2zx0otQbTeI5AS1/H7hh2hqXywIhFWqNly2ED5vHQThJCSBzN+8u3alMEeKREKBfGfhqryE2tDjG357ao5ZzsR1cnwgkDyv6TaUtCFMT6TZxVpHFRTqjj+YgB8yEzYhkcNIZC//ylVlwiwhmaG9LDKf8Nb9jOnvySvL3PjKdbj8E7X/onrpFKqeivqZFVqNJmyaCNyhMxzkmEUeUR2Mt07veuorce8d6ln3SS/SY6jjqH2TWtjFh0iFG7DH+Ns/+LW98i2Cb1YGExm9p1o5Aty9qV0wjCz1lb4lmRAz+dhpJLpO9inwytP33U3Vv3wjVwvBm6LPLnLQ6R6rFzvHeuZzasBca9rs4OmZUHOjn6yFzQ8y1tPZLC7imq6AgMdcKFhX0ugTBOLWGi42WSOO/IEdUVsh1SPs4niIs6bTF0WbeUDx7EeGIjOeZzUCqEHHHlt17qb3WUBbKzfasUKOCQNvoiFZrnpcGECZrFbygo39MguS6pY+nGjwby0nSkA09djlepB1eofzmo02C70SMbBgKzX6aHPL1g9jtCRq9IR3M6R61+iiNHBHczc00YX7O8urqcgPdFgGYnwO+KhleaC+5Ku+ZvgGRHvHjdUdADfQ5sU/5e4k2YeFiVjM6+Lrz23ctOJksflIoAsaft51je0K4RJjtcW41dkWaDyoj1rxT3xeY7tRKyeIz58GvWqDHJhkRP8qHgj2RoZZeJKnO6gVCE3S1aPh6ktx1688i3g
 BOdyXeQi
 NPQatwh6HJI9hyOPXFwd2VfzeG9bo5rHZyDUcxjubJYVpQk6fcNKutKaBthAX03qqhEikWxcxw/1HRP/eyVf6v3DyjYGbxfZYnwdde6ehTrZprKQUykqUahQ+vEZuSttPi7bcT8bGCGxtso9tYILvkqBKtlW9VsVxmP0HlozZPD452gGUvUJfrCZ/+58AQ8h8YXiEaF8NAkBlBUKWVFVSxM9j/ZLmgq8toR2GKuNPcTKEtjxOvMt5XHhYTohurFexiu5p0uZhDNy6UHOlBzXvsO1h1QaWjk06nYlv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Hi,

This series adds some tests for memfd preservation across a live update.
Currently memfd is only tested indirectly via luo_kexec_simple or
luo_multi_session. Add a dedicated test suite for it.

Patches 1 and 2 are preparatory, adding base framework and helpers, and
the other patches each add a test. Some of the code is taken from the
libluo patches [0] I sent a while ago.

[0] https://lore.kernel.org/linux-mm/20250723144649.1696299-33-pasha.tatashin@soleen.com/

Regards,
Pratyush Yadav

Pratyush Yadav (Google) (6):
  selftests/liveupdate: add framework for memfd tests
  selftests/liveupdate: add helper functions for memfd tests
  selftests/liveupdate: add test for memfd content preservation
  selftests/liveupdate: add test for zero-size memfd preservation
  selftests/liveupdate: add test for operations on a preserved memfd
  selftests/liveupdate: add fallocate test for memfd

 tools/testing/selftests/liveupdate/Makefile   |   2 +
 .../testing/selftests/liveupdate/luo_memfd.c  | 306 ++++++++++++++++++
 .../selftests/liveupdate/luo_test_utils.c     | 175 +++++++++-
 .../selftests/liveupdate/luo_test_utils.h     |   9 +
 4 files changed, 491 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/liveupdate/luo_memfd.c


base-commit: 6f04517c06a898228eda00cbd8573d9e84003108
-- 
2.53.0.473.g4a7958ca14-goog


