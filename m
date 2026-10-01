Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74B95CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 06:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60F5E6B008A; Thu,  1 Oct 2026 02:00:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C08F6B008C; Thu,  1 Oct 2026 02:00:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B0126B0092; Thu,  1 Oct 2026 02:00:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2647C6B008A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 02:00:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C9E2A6880
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 06:00:31 +0000 (UTC)
X-FDA: 85273007862.29.57F9007
Received: from mail-oo2-f10.google.com (mail-oo2-f10.google.com [74.125.231.138])
	by imf29.hostedemail.com (Postfix) with ESMTP id AC8F2120004
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 06:00:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ghz3FrEs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.138 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790834429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=86MBDdoN8+nPFAYYb3eyEgckb6tHnNUv3pn1Zb+pPE8=;
	b=m06tNCxxmZxK7zvkHxMmfAZnQ9wTEI4Vf5v/uzJEmnWVbGjwtQg2Erw64miMhUA9zmx0zP
	JBLHmTPNjznX9YOQ/R1DpZdhTD2QdyL9XQ5jkPn078BchuNAlrfneRtSzH9ju5rx/C/6BV
	g7CXbuPDExgG3E2tCi4tkZoHRnilmus=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ghz3FrEs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.138 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790834429;
	b=vuMIujo265DVZ9Na4GtvVRFOkIyR4teGeUWbgZNvoX2cVqEx5SD20C6e/wpD5SF1Ssa/Kc
	NNbvlNRaHrTBGt6gNklbDfLVjZ4THypIAZUtnDG9CTDruBgbAJrhbw4SIBAQZ2cWZd8AgG
	vYW58Otu1UyVV0oyZeEU3EotryPUSB8=
Received: by mail-oo2-f10.google.com with SMTP id 46e09a7af769-820ff812cd8so236655a34.1
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 23:00:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790834428; cv=none;
        d=google.com; s=arc-20260327;
        b=SYoSEVOS6/5/0wF8eIbSQx1JEHA5/XI8LhANVF5MNq33IA250ki3nDHhWhZTlOzHus
         WEvTtUaJYoY6xtj1pLtr/VL5vNY1iel4gbuEBnClGhWFCnAIHYLW11FmydvPViBsDWSv
         cPpDvU0dSP1oDBP9tMpEfUdXCE4WoxwXEJYvjKgKlYuZdC6h9ldwBYGjbKILglp6O9Wm
         tQko9nP7r4xfsP2QrMny9Cx9xaLjGu2ESkcQyL0m1v+Zsfe+HnSj8eDmnWUwXilRzI9p
         BAf+VIYPdM+vHiTuyLrgdkMyXAWa9On3HELcONIF3gZARS5zslSVBwhmZ2mWgfIqNxgo
         HpUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=86MBDdoN8+nPFAYYb3eyEgckb6tHnNUv3pn1Zb+pPE8=;
        fh=eXrd+9ThZ58smNuLJIwwbBfEy0ulMuXWzyDnY5sXsg4=;
        b=fzRxVc9hMel5ocDXkVtRttoKF+Nbory48VGXB4Gc4MezByXqVZqSsmVk7uZRJnYvKh
         PGDDL/S4gvZA1vwombDzHFnXZfiSQAcZgwenChwcQikHOIzseaQoe3OFytg9+asoPG80
         Ae9ztn+XYbug/PkbZSto0qOuBxZZjk3qG4j2I8IdhP6Pfl4m7URiVxQJzlgmKzbi8Cyl
         37natjVrSuECPnrSv+dCF5DEZbO8AeBhYsgeyPkPa++CO33YYkHtov/bNw5ZiGUj0e5P
         PVwaFksThjba8CmMgSoXcNMOuS2nqSX9Bh4G5xPqAcSLrQQ73zGIBnEhPqHB7OMICymC
         u6TA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790834428; x=1791439228; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=86MBDdoN8+nPFAYYb3eyEgckb6tHnNUv3pn1Zb+pPE8=;
        b=Ghz3FrEsfx/Km0hPK9yi1oAaM5Es1CHj33weI9GkCiLYnsQjoLkZiNGXxQXr+qPVUl
         h3R51GCZ0Iqebv9mh7L67+H6ViB8zTX/YsDow59jfNsy+8yI1DMleNbVjtbsL0FoeLZO
         xBKnkuP8qPORbpQ2LkwYwg7z0PWPVIUMMPl15lQ/OSVOyk2yUSZOlTAhHFPbGiQUdc2t
         d2HpQEczN7xTrkjXatXtsDw74ILqMW8U5JVu+gZMBtjg44lV9V/E3ilIFefIlT8+O4tS
         Y1/LWrQ3Rpmjltdf/JAe0e7t/88YnpC5Q+TXBsXcuSpqlEcCSo8pzxDPJik4Jn3c9kPN
         Lo2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790834428; x=1791439228;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=86MBDdoN8+nPFAYYb3eyEgckb6tHnNUv3pn1Zb+pPE8=;
        b=fLVZzmAhjAR19EVs+QpufD/n0yhCUoCWOcHrM1ySurITRIvRVIKxZhqFC2+iAJbmBk
         zjMFyEz4bAa3wssrLfH80eMWxBboukgB5lcidCSP/gw9VrkBpdOB2kcWMtU/pc0e68Po
         gZCf3L0GqtT1+42Q9/dhwCptperUFIW50yrGVU2syZEmbVdx49CfuBI/XrV/oJIsGox8
         SrGkhX+fSO2BV6EGX97JoUgaYXQ6Jo6bVELBjbYVhghfme9Natv3KQ0R/qeXxMb7Cz7Q
         kNKfTWnQw0tOwW+t8zkriP/H/o2ZZ+A46vWXdw2qlcv/Rf3OOtn2h4JvSAyDuULS3H9y
         MF5Q==
X-Forwarded-Encrypted: i=1; AKwUvByHGA++dmg7+e4BRHKqMp5ztFVNiyOMnFD1CaFYlSNpeuQG/P87pYUUiLxCjpSGbOj27KqmjzkwgQ==@kvack.org
X-Gm-Message-State: AFuF++m3mFgGQdAc5SFCcp3iCi44lpcOqiXdTXwHO/vWV2eP8oMKdXf/
	GfY7aleWR1NXSPfszKaXsXtsLvs6u8XzTgEogGt41GOo6Kxhxh/rzhPWAYnDuS8EP604XkvR+KW
	asM9cI/rx1Bu3CbSyhnyEeNF0Ql2Hy2A=
X-Gm-Gg: AYBFou3mPTohg9NE9xQhnQ8KmzGo9lOeY1rnWVBZ4HN9H1QRxoR+2prWlN9bW6059VE
	fm4HoA2rAfnzNLbVByWrUV9TF9RKnkMiyBbK0mYEviNLxxztPHKqiJ+M0NnfSAfvN8yUi83H93u
	PynjHf2D+pXqTmi47Q+eGY76KN+fpwi9g6voj3NfxSp1SLqXtH3aW5fcTt1nrLhaFiIFYBjXX2z
	/5gogjyCDOSywST0MrIYo10I5AohnD7I8hxGK89A3f3oTCj3DL13WgKQs+Q6yt+QJq6B6BMvk56
	/iGqn2WTbpwfSloc3wU5Fgr1okU5mwK2RNAaAMlNISnxc0VczV1ubUWHx5qGHtsYufQkOaqQkbC
	xDElWE6mbmQ==
X-Received: by 2002:a05:6808:c2d2:b0:4d6:93e2:5bc7 with SMTP id
 5614622812f47-4f1b937789bmr4169206b6e.67.1790834428301; Wed, 30 Sep 2026
 23:00:28 -0700 (PDT)
Received: from 578479312649 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 30 Sep 2026 23:00:27 -0700
Received: from 578479312649 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 30 Sep 2026 23:00:27 -0700
From: Aveline Noir <jm5905938@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Date: Wed, 30 Sep 2026 23:00:27 -0700
X-Gm-Features: AclHuK-fk3VgJqHBfeBrKPt-2j6Rf7JJ_J_9SFI-Q-5BndDxw9L61bmuFQdGI00
Message-ID: <CANOyQmFzsssM_BXHUDrV+UuVD5SZMBmSkg3UQnmw9Ns1PV7GCQ@mail.gmail.com>
Subject: [PATCH] selftests/mm: mrelease_test: fix retry limit
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Christian Brauner <brauner@kernel.org>, 
	Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: tbdj5q7qtycigybik5xnus7x33ws6pxa
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AC8F2120004
X-HE-Tag: 1790834429-150537
X-HE-Meta: U2FsdGVkX18HeVJ5AjcKZhn1T8FK6cLlL+C6CB+1NsCuMLKtq2Ulj0jP3BXVGyZOZNV3L2fOyVCImOF0RWTRWM4h0vA1znukTi0zkrG3n/1Uju04qv9R64qocK9edNgkWKLEVGQqT3TNtV9M/qQaBS3Nb/9PNr9zVxqaWfFUzax7QZBs79uMtFpFTbZjvbaagBL1vu4bfhH7Lat9f6GVFOmrDGCQZl0uqy1XOFkYGenF9IFjjxmzr69kM3UKoSTMEfUceBVna53a+tkKKOmzURY6vU7wDwSLv/ilKUAYDX7suKtWb2DGZx63hk7V0Z+Vjj9m9STChkMHoBkU7iZnM51flQ8eHnUepzALLbj4uwpFMrIUBwskSURDLFcZo8KndXGirwACQm0FWFQsdwE2sUwnvPAA0HeujLvxqbCaAwGiB2qs66I/BFWKa0NsKlmoIT9wy5uCDAZMAYYxIk7L+tZVDJQ0mvFFvREpI6XUwsficeO+dqL0jJ8wuyYSSutgm+lLGKiyRCSV6IzQe4Su+BwhhGD2K4gcrD4kQPXVfxhLJksLDvP8ICToYIBnAYPwhcLHh3jlfvTGb3zeXn6D1JA1CSNZYj2vcYtoS9y9ALq2puBwTYl3uE9T3Lw/vn6ClRvqapqGLuru1ZVSCu4cH9R1lHHYDB1BHuEFtPrvg1MqHEdwRqrs4GAmtRQiiseaYqEVE+tdOnyeGYz8P4/NO3b9v7wnM8tOQlNhQdn8Wu+PwZ4lmgkdeUFPaEUMvrIQZo1Yvy8Mf0+pZDKD6tHgM0pKCDovjDfIhv+FZe+mNPCwZIBbhSfZyu+gZ3pF8Dx719oBS4XE33Zf+Uyo3kN0G9c+jQBIGRgzFyslNt0923moGeRuZ8zHM1+OTILgwvOemTg0sxLotmUUXpD4cw/zh1/eKyJmH+oUgnpzxhEcSkTmVgdpG1jbnnzYvh/7w9jADOKOxRINZPN+s39VlR+
 KKmyy+NT
 IDxPM2fhk3nTZorW+f982pA8VCRggCLZX0Cii1fVCt4DzwLRVdLYWFAO2+xasVkVHDw4Obq/BhiSsTPKv8kXw1HZTQPa6gPsHp6js8yxQrmy84ac5RZjsmC7U2s40ns9MeULOC8l8oGHtmB/gLC6+AyzP2RG9tW2c/TRNjK+hgqwx+5C1j5EtoYtujISlirOBPMVYL+sZOAgLvPuIrbrFb7HYL/WHXYmHqoA8HA90dbwrPdOhPdcv+dfwpvtLSi+qVip72dJYXhJ5qzwW4Id/9NjQFuNCtf6v9atYiX87iWKC4Z53KbiQyPin9LMzr6H37M+Q4wks3DYyn+kHN43Z02p5XMrF0kRQEoQhkXTK5fjnqdTbKyjMQCNBAIfscyrE8YvN4r/ECrUjGBigBDY/PttCa7ujCPz8quCzSqByVK5B9B0EtRl2iD8aOzScQL3vb865hQNpXZdMZRtKdNybtNTQ2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mrelease_test doubles the child allocation when process_mrelease()
returns ESRCH.

When size is already MAX_SIZE_MB, the current <= check still allows
another retry, causing the allocation to grow from 1024 MB to 2048 MB.

Use < instead of <= so the largest allocation attempted remains
MAX_SIZE_MB.

LLM used in discovering bug. Changes were made and reviewed manually.

Fixes: 33776141b812 ("selftests: vm: add process_mrelease tests")
Assisted-by: LLM
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
 tools/testing/selftests/mm/mrelease_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mrelease_test.c
b/tools/testing/selftests/mm/mrelease_test.c
index 64e8d00ae944..a5124c9e9f43 100644
--- a/tools/testing/selftests/mm/mrelease_test.c
+++ b/tools/testing/selftests/mm/mrelease_test.c
@@ -157,7 +157,7 @@ int main(void)
 		 * Retry until we succeed or reach MAX_SIZE_MB.
 		 */
 		if (errno == ESRCH) {
-			retry = (size <= MAX_SIZE_MB);
+			retry = (size < MAX_SIZE_MB);
 		} else {
 			waitpid(pid, NULL, 0);
 			ksft_exit_fail_msg("process_mrelease: %s\n", strerror(errno));
-- 
2.55.0

