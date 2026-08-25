Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C574C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 11:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AF316B00AF; Tue, 25 Aug 2026 07:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486AD6B00B1; Tue, 25 Aug 2026 07:21:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4AD6B00B2; Tue, 25 Aug 2026 07:21:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FD906B00AF
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:21:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0355B80396
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:21:19 +0000 (UTC)
X-FDA: 85139550720.14.98292C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4C0DCC0004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:21:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UWzSPvTl;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787656878;
	b=6o8imyQCZGPPBlZQjQQVuZhImlSDJa2MFYjplEizaXV7hyE7Av5gWyu3xjAA9qh98lwKbz
	QbNEM5Up9zbsqnm3U7aMbOhy42+bAqs85Ec6F9x0volZ+Z0e8W4X/QsZCFlI/3Kclyn60/
	Ko16+Mzrng3Y4nqugVbWmlRNkDGjJ6k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UWzSPvTl;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787656878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=h8WSm5E7RlGy21wvox/gCKYIqtupoRWvitRuKuzB5iI=;
	b=Q17QFhQbsFNHyrwwqdorrVN9oqnxYrA7U6rxUtjOOmmRBUbc68qv7CHBMIbSyPNpHzrBSk
	lEZLT5au+j9edDj5sgJBdzKlcovYIJV3OkJtpSx8KsFFxH7fq9AmsCdYZZmUaPL6xl040K
	CZ772a+ujF0utGKhDSZXn5CWdASPYKs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BF7016011F;
	Tue, 25 Aug 2026 11:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B42E1F000E9;
	Tue, 25 Aug 2026 11:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787656877;
	bh=h8WSm5E7RlGy21wvox/gCKYIqtupoRWvitRuKuzB5iI=;
	h=From:Date:Subject:To:Cc;
	b=UWzSPvTlT17GOPXKdB2QDqA27AvjHK2nMD/TzWVxOyffkoNG1q0ENJWpQ1HjB6JBR
	 Q0hPzAFedJMTH4MRz5qAYglF2NmDiCxAU2bVoctsQrNEUf3Bnpwpzx1+kXWtpuMqV1
	 tuxfqm0GfCvRiMfzHzae19/gLrsq3cQ5HrC2IDA1lFJQkY2hqqBpftYcT1AQuipcIJ
	 OoMc+GU9WoJHnRmdqm1ih8jHn0rEgFHamhUxQwTC+D6go+2dmcVzQYiXArF3ZFT0+W
	 kxIRBcngGACA1g6kmvoTNlPWbMcMEJvncbPsfzXVXyu3RFaKbcfNrNM+rJ1Y9dsTL+
	 jinm2F7iHcO2A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 25 Aug 2026 13:20:59 +0200
Subject: [PATCH] selftests/mm: khugepaged: remove str_dup() usage
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260825-remove_str_dup-v1-1-0ba2121a820c@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJp6jWoC/yXMQQqDMBBG4avIrBtIYxXTqxSRRn/tFKoyoyKId
 zfV5bd4byOFMJSeyUaChZWHPuJ+S6j+vPsOhptoctbltnCZEfyGBZVOUjXzaEKwhYdPrX+0FKN
 R0PJ6Dl/lZZ3DF/X0v9C+HzyTaHpyAAAA
X-Change-ID: 20260825-remove_str_dup-bb089e93094f
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1154; i=david@kernel.org;
 h=from:subject:message-id; bh=qZnOR8M4AndwDXO1OfuZmJMJJhPcOsrYOXkrmMVezfQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ6q+YWHl2+pORhy5P5u06cfNYb/tSIqX/RQqMDiXNvN
 RyVXKMf21HKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEFL0ZGW4Z/7i7tp1LK7qr
 fXunywfDXI5/7nnctiYuru91l2ro7mb47zt5dyj7/I6bGkrHJ0Z84+2yt/q5JNRfcOmaO5ob11Z
 HMwAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4C0DCC0004
X-Stat-Signature: wuxs65jaxzr1rmxz88tkbg4skdnw9ff8
X-HE-Tag: 1787656878-5434
X-HE-Meta: U2FsdGVkX18EV+XEL6vq1+i/fGShORhXibVZsCrFWzlFFI+QPjzhIchntyMIcYZ5PSDojhwAQ33X/TRAnc3v91SW/bQhHW8yMOu3OpOayttG9oLSscazru7RUS8oFJrYHL5aejNrSVAKq1lW5rRtwVmj2kKUgcVaaCPxYXbMt9RIGD17jOJ8rnjFMZHdEybxn5jsQWoJYf5A+acbqt7FtUSkwt/mS0XM8WTYxfuKoJlyRc3MSrbq8BtsD1vn92FgL32+jYYNHbcqi0F+jHhJKgy8KcTss1CrqqUQfRrMYRXxjYldLlFpG/8ZlTDCLbdljXgXhFQYzdjzt+4+He4iLlGO+vtZlYT6S88GY8KVMpAzqfG+msnZ8uxXgVqqZLkg9nyrl+2w8X3F+UjEOEpBkRL+aNy+u0TaCuuoH8Fgniv22Pwob4eKp5eHUvCMUKNvJrymvlH0ojmz2sllOFjefSKKUmlptScT02WSgzQBlYTDLt2YW0mNcmMAkPzyvyHsp2x9vIP9+YmsT88UVvgHHzH2Gvegdpdw0M4jWzbDeZz1FjZqyQCrbjrgJlk/1G+6oAanWyU3M0MeCUWML/tQ/tU+JNxmPWryMSaBa3WIy77kdfP8P+JepfgrQwY+F6V0obIrWXE3fZFCDUDndoIEEruUaadB0LaB40cSZCPoAnYXdePgVH2S9n9uEYdOl2GXydXWLnjbJuPZ9rKXGyRQqX4kEH1PT+6IFYhtYNeg0oPbjU2NBwxrtaf6xacG4345kqBhcdvMxn8Z6d1Xgg6XohsYEaBlAaGY9+5YJpI6GcVKGbH/LohkJeZlXXCw/ZRNQUrhonrRzVc3NkFTfvkJSU7WEk5VCs3vh8uOsbH/HVY0ottPvhteHXG9MLqXXw1Ya+IzE87MtqS2cwiqq60tZoElwHd85kkgz3dkqfSupRRijh80G9rwUFTC2I4zXfVimd6mhZDmpBk4mHShbrf
 oeW3B8cv
 AJ+gYnRB/uiZWDI974Sev2BBsCP/dHfF3U5tH8M2FS9YkWw1UL1XVGd1EK9MCAXBu9JQCD1CdSIlXuEgGql1N4wxc5YCGSHEBOE8yTH/TqEWYKHnaFhVpdpWhGD7APqrosiCznysBmsVrtjBQwgOUSjDuSKymSQc9txrJra4dQ6QkWvUrEJ9C6xj1Hk/91ywbDogpCkA+C/3pDcvvLO7NSptjQJp2gBJxmouPMUkoEQGmBRjk3Bnyf6jKgWW+ORnvv9cQc6rSV4ZuzG13sZdWQJo5jSkMLPa50+sxZMM6HFCAXVeWlumESBKek6kU5+HxWwAW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We don't check str_dup() return value and never free it. While both
things are irrelevant in practice, let's just clean it up by working on
argv[0] directly and avoiding the str_dup().

Nobody after us needs these parts of the argv[0] string anyway.

This patch is inspired by previous work from Anshuman Tewari [1].

Link: https://lore.kernel.org/r/20260821114416.12255-1-anshumantewari123@gmail.com [1]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 1d2d6bd72fd2a..83d27d069c413 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1227,7 +1227,7 @@ static void parse_test_type(int argc, char **argv)
 		return;
 	}
 
-	buf = strdup(argv[0]);
+	buf = argv[0];
 	token = strsep(&buf, ":");
 
 	if (!strcmp(token, "all")) {

---

base-commit: 169393fff5d1ec2690934067eeb95544ff5ebdd7

change-id: 20260825-remove_str_dup-bb089e93094f

--

Cheers,

David


