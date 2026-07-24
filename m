Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6B1CC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 07:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F15DA6B007B; Fri, 24 Jul 2026 03:00:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6406B0088; Fri, 24 Jul 2026 03:00:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDCE46B0092; Fri, 24 Jul 2026 03:00:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD0986B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:00:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 216491602AB
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:00:56 +0000 (UTC)
X-FDA: 85022772912.09.BE7C7AD
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	by imf07.hostedemail.com (Postfix) with ESMTP id B133C40008
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:00:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=Cj8RwvZk;
	spf=pass (imf07.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 54.254.200.128 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784876454;
	b=fnMePROX6YSalEk1xx6f1bZgi2PUYFQcn1rCeD6a2ol7Mq1APbmqu9WePbNdU1nufuizBZ
	KZ1IVCwag7g6dm8Ijb8eko8nGU1s/kK37PAU3Urxzyjp/fiKslPsQL1Nsp0c8TNHO+VcaW
	DPI3iZeFdzW2EIwvsl/lRlHicgPcfhI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=Cj8RwvZk;
	spf=pass (imf07.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 54.254.200.128 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784876454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=W7eO75WQ6Iz53aPxHGA+pWTqSaMtwGzSjlsEmYlxr0g=;
	b=YR8hfhXZQbjV3RdfE7n+ez96H/HCNcN1VMwwc/oUA59levKDhwSrMHCjBQA71KmdSAqbPY
	jEL0GS6ps0X6Tj3MFYl6WPgYiSb90BXpiqBPfkBcSnCXvpF7RPAYyqXLqCYUgwSBYpq2mM
	+Rj+JrneqlFLJZIQdko8lRjgtU9tgOU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784876438;
	bh=W7eO75WQ6Iz53aPxHGA+pWTqSaMtwGzSjlsEmYlxr0g=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=Cj8RwvZkBDOPWBOxGGiUhn6GEuh1EyhTf2CL2OHxYYI5ArPZVDca1kD7R6OW9Icu8
	 LDtCXGPoz02DhLFLXkP8ySBu+WCdlS1Pb6jCkR5wYiVACsGgq7RsWK77zNTxC/SBDB
	 MgIr1lZxJwqEZa3VpXyG2EbQ2I69UvVdS5W8YORI=
X-QQ-mid: zesmtpsz3t1784876420tbd8998f7
X-QQ-Originating-IP: Vyt5qy7KqQvsjOwB9C0qk1I1TDMXxLRBNON0HVtOncQ=
Received: from zzz-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 24 Jul 2026 15:00:12 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2749011430090212202
EX-QQ-RecipientCnt: 10
From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
To: David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Subject: [PATCH] selftests/mm: fix gup_longterm EINVAL error message
Date: Fri, 24 Jul 2026 14:59:29 +0800
Message-ID: <8A3ADC563A32EF67+20260724065929.1474539-1-zhaozhengzhuo@uniontech.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: MvdkdJf/zMeNq6Gdr4/GWj+x1cjfk1QMJLKvHmyo69uiV16HwW/Mv8IZ
	Uo7/6bLwpXMwrcos5nVAv1BtvISXRiFrL23rhEm8O+90SMpoEpgPzHsTtvbn2Y+OB/CY+G4
	kJaRIpStOw4GndBTLfch0XJyFahuhRzKohyvQEBX8pXVikHVtQkGAuUakjhYdaGVRNR7Lz8
	wci0ZxWFYGvGpPDrhMV0iZGLlfdSVsI/srezOvxFj8FvwtTcbxB8EaNabO1YO2wmpROnVxL
	RAewdLKd2DQKF82lZhY65OJqTz6BDJsxS9HQYkZac56ULBUrbOr0gOB85aHvflbTFEQVp7M
	5Pp2qcKgorX8tSjCCxL/6s9WRjsocgfj7DMiYvMl4tfpey8o8z4oMc/imqep19zazyNDx/5
	MXRQJy6m7Itoqz9gdZQ59Kal+hzGDzHmvNPsp9TIrUxMapL17TMIisE6P8A4waCvSgmzrKb
	vCFHQtZCaG9M4ip4xfdF/zVm5Xmo2r/Hc+jhU++Pboaep2KH9W6rZT3G+oU1MhzEMkKEwAU
	LB1NbNkWF+RrOc/ObmDpVZ1NvtFNwf3jMBGieeyTmqDv/lRY46uevCHQ0zRJgljZ7ZZxZ9s
	8OO7zeyGxbLC+BJll5lcqvIsHHYU1H3/9032DcEXDanlmDIPDjN2demNZoXVM/KeKLf5UZw
	ZbbpLXsZUE6rMwrWQkLaOteusL/1ew1ivL1KpogeyxeYk2/55nGDsEvWS0jzFisMwgJKh80
	1+0yu3NgcXyZCTD0UTD63mOoTUPvpkjxUQ5HTHriDSk4GaFQ40hxqIBSc76DIhKwsemZ27J
	RfSy+Ki87E86KO2wrI0tMtZAnzw6wezawJ57Yj8HfOB0iv6Nj9WIDUtorbbch5F9XCiICg6
	2kvTBMRcT3vgJVGFFnlCgezAYStZ7g2iJ5nqXenDEyDqfIWO55W096R3+a548G/w1lKfOMY
	JlCL+52DQmuKAOd83xGY9zQMF6HryPMSuRXWfWLwELEMbJayGqEf5mtYv6Idcli6doFsT9D
	kwYX2Qp6khjk3VjtuaRK0e/jFyETlrxbHuq55FvdQ4bantRDGSec1qRDoRpgB19z37FiXeL
	lU6TigE7DHEly1KhyTxuLncYoW3ekcyGg==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B133C40008
X-Stat-Signature: e3i7ka7uern996xz5315bsxd1od677df
X-Rspam-User: 
X-HE-Tag: 1784876451-798024
X-HE-Meta: U2FsdGVkX1/LUzBfFRUHXliUhYvL5dUjyvDPmQHkAsY4iuIyFXFHrmch1BGRaKMr848SWa2pYxDDsjB72fZAD3Q0RvFKBKSVxgRKn2O66L0HVVHk6X1PyQLlKFI+TIo3PUxplOiIfWa6RIkk9j4Ep2Cubww7fDD3fR+4zT6HmEUwG87P32CSuXPkicx3diFEDM4Lj7z33qLVqLKQCgX16EEikZNNbMryqfWWORMJ8nnHx4cavYPAuEBPuL9UZf6OoVCineIkLBi1v6/aoV1DJpiBYctBDKPzq9aLyFhHfNYW/WEwcA8T281tDmgPv+HpxRtq6Ih+9liKGcYAuT1mjyfkigUz6hdLNxjk2jnjmPYeX9oTOdohdp0Q7qNOSN1l/Ujsf0CynILaWQe/xi/UNaQHVuqjeFqk4THH7xQWRMCmKJLi1r7ZLO+ciF1vXM9yYJTw6zTSt2xwMHV91Dra7BecdjB7HyWfn9qp8+VM4IoewhV8NA9VflWXDhtBbpL/4jwqUGxIRwqIKKwKzIgH07nLYFJgdEPMf6VSQsEIkOIHeLyS/XQ7lo/4scTI06bdDK3vdrG/X44mtdWnUlj1EMlM2JbYMu+8RY4rhRNZwNH09kSq40PFl8T/SEVx7WKiI5gt/XcVtPqjIZOR+BA++c3bL8RxWK7r8Ap01SVE1a+N7b1wj6+FEuTLlB1KAiY/Xw5ENyTgyjFGu0GmcYK4Y6sD3882E+6e/PmEUGHii04s7m5gM+c+LUDYcZrI8PMmrQEDtMwn7Ne73xlP1Izra09bEiOi5eJbfbdUxKcaSWSoZkFMnW2x1sgWeuugZcF3hiZqaoT+gKA81srjwbYNJaM29o9YDdD5tFpCofwv6D06eeLuTDGLA3lpX8VoFXkXX4AKActJAc7+jdsl3K+KhbI2spooqWmQBl3/eq2W/NHefmG8FXxTcM1iKE04gqdlikzYlFV8R90m/BjvIO4
 0vC8GdUG
 m+Fwzwewnr7tiB5lkoxe+4yzMRmAGVl2xkD7jLj6Kx9YBE5txpJau/7Xa3G37j3bzVyXhR7+3W/xHDXixYFr5kIbH1S3VmhS5khjgLL+1kTIi8SEd0Hd1GK37vQ2b7GgcB3sOBbLlhaq7FSf5vtM6PqcbdXKYoM+7xXW+loA2u5gJUkezAqSFrYCE/uis5TOii2eFzwALnjiXtgboUWohNvni5z3AVtsz4b7UARp1ajYlikebpg3JL1S0a1C5pO1Ye5obeAlXuFzIItPcmbQYmoNQx+xP8tbgg9fh8fhOT2hqjBaWHYdvG2qE4VwywN0fEIoHURTLOWP7nsUFyWNkImQeDqVFVse8NoprZyFAqcmGbfoR/+fC+Mm29rQMx8KG3t+jv5hLDb1oo5qyDjra58/lhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The gup_longterm test prints a literal "n" when
PIN_LONGTERM_TEST_START fails with EINVAL because the string is missing the
newline escape sequence.

Print a newline instead.

Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
---
 tools/testing/selftests/mm/gup_longterm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
index eb8963e9d..c03b4f891 100644
--- a/tools/testing/selftests/mm/gup_longterm.c
+++ b/tools/testing/selftests/mm/gup_longterm.c
@@ -196,7 +196,7 @@ static void do_test(int fd, size_t size, enum test_type type, bool shared)
 		args.flags |= rw ? PIN_LONGTERM_TEST_FLAG_USE_WRITE : 0;
 		ret = ioctl(gup_fd, PIN_LONGTERM_TEST_START, &args);
 		if (ret && errno == EINVAL) {
-			ksft_print_msg("PIN_LONGTERM_TEST_START failed (EINVAL)n");
+			ksft_print_msg("PIN_LONGTERM_TEST_START failed (EINVAL)\n");
 			result = KSFT_SKIP;
 			break;
 		} else if (ret && errno == EFAULT) {

base-commit: c04df384b55dd9dcf72c36b661becb5aaba371a9
-- 
2.51.0


