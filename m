Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62C27CCF2C1
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 15:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 707166B0092; Sat, 17 Oct 2026 11:07:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DE6E6B0095; Sat, 17 Oct 2026 11:07:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F5A36B0096; Sat, 17 Oct 2026 11:07:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A25E6B0092
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 11:07:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D390C8031A
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 15:07:34 +0000 (UTC)
X-FDA: 85332447228.06.25FA8D3
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 04CD2180006
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 15:07:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y8BknUFX;
	spf=pass (imf16.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792249653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBQ7X2jkYefaXYnnpfuBlQ4cNKv2piH6HTiOHbSZfNQ=;
	b=dQ157yTm5vPohZkhtGa1fcnYyarM6I2I/bCo/NjV8NSejQf/W6GK/VbESqzqjm5uvGRiDD
	AVjk1/rtZErmZoPXPOyxTlXgigZ9aw2OvcJ/FCjFRBHqamBIzOMXaCmeqL1LvxOclvLRTk
	TVGFHoa4bFUwcLgpYedSg/CS6Mdm3L4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792249653;
	b=pUB36l3sHj5Av6f/ZtJPofGyJF23tLrlUt3+lj9oUc7zb847ZaDoXmfoJ2eKXxy3NYA+++
	Tp1Amk2Lk6g8z6kErDLK2Il6Y3Y/Y+1b15L/pq2Z+0dQr139HiruPwvESI9rGUD4+IZXus
	sIv/PPF2UOWJhbAKu8ytlfRkVHFepnM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y8BknUFX;
	spf=pass (imf16.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-15943c9c005so619354c88.1
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 08:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792249652; x=1792854452; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RBQ7X2jkYefaXYnnpfuBlQ4cNKv2piH6HTiOHbSZfNQ=;
        b=Y8BknUFX4Uhv4Bi86gYFAkh/vjRnZRWU3IQ8ORs0I0kaYcM49rGSOHq2O633kH/ijH
         kzl7rOLITfFZ6975s+Bbet4MvEDuR2OZOY6+vffhbJrtAtfKLw4BbTC6srU/lrYBkCh2
         kKZb8H5/407ArGXq8gGiKzto6Ti+VkEBYy/LxAgcRABUh06EfJRvgK95N5uRvusNIIFJ
         ZPhYq73Z8lCIhwOUbp4kwQ/qIYokyBeMqdj9rDw+KQJtvFmg3g6y5EwbH0TYg15mH3Q8
         /vcvVanQjT2CjPfBkESbcVBAcE046D74mPAR6jYTlkJC8x3SkaY4bpSMsRDmWw1P/fVy
         f2CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792249652; x=1792854452;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RBQ7X2jkYefaXYnnpfuBlQ4cNKv2piH6HTiOHbSZfNQ=;
        b=SlkXRDnR7EFZYv/JLe2OQF+ErGd7xvabo7MGhTMuy7fVdWiS8OTPTuTCqKxE8M5SXx
         T0/uG7FNWWzrDA911z0LkcESxo6BdR8ofPYNwZoiAKuelJI6t/jU8nxylmpoOLjqqISa
         NyBooBqn8Z9nRQexzKUgTcxW5fmVafIpXb4zkLuj1G+EWOfnR6dOHsIUusPFv/oVTASo
         dKAZX8yI+V9qXRPeiaZwv1gsIwLA3mbDRPRF6GtJlvKInykPE5d8XgEPpDyEvHPdq3ov
         ZMUYBcZwrv1vjow1d2+HQu9SadPKL8Vzac0JoyvgcLfX/ef/oPxxgNS1lttP5FTd1BCZ
         BQ4g==
X-Gm-Message-State: AFq9FYLqJnPkds6BAhaT469AKrvd3EUtgYjmpwLIRP49uyYWnficQoUC
	BFB8L9xfI434qd+zmxtzQWe0VuR/+P4+Ui56c2Fed5X3RgcqH+NA6fPDJCX1mg4q5fo=
X-Gm-Gg: AYBFou3f3vSzaCTaJWmVCTjzsjtYegfaEgD6u0SoEFRVE8IP8viwqMQ6e6zQH6dsIRo
	2YdGQd5WV9Lim+uYNKeIV758BesJBtcYQu67YmsxDVVCT87Cnaf0p/MMAFHWeeGjFcR4DC9OdAH
	cTpBut8t5Rqptk82NZvqkO5ORV6yE4LNDVzro0M7Y7d9Qot1/OLx+h/KCRFcHB057VaolNgC4t+
	hgLgrbSBdSnkgywYesdY2anqp+FoAGKK9O89TIfM+zopvUVvNsl0tfpkufkQAtlQ1unYScJK60p
	z1GBN5JWk89CBRoq1REWtF3S0zSmIJfH2f4Xabm6Z+q29RPQtYL5sZDNmq3HbOikr020H/S/MMp
	rWiqFvKCO8wmYj4tUJtWt4gyauYffRkyNvxALVY97uO4Zw3lbosOMizx4MMMIXIZJqbgrYZUTSb
	K4CmRlUwdTfgBQ3VjAMLiHGBA4EPy8xQ+HLqpKjaHDo/8wg40TNPjkY8M6tqZfFlH7Gw==
X-Received: by 2002:a05:701b:455a:20b0:168:3243:c910 with SMTP id a92af1059eb24-185120a88cemr4732337c88.13.1792249651516;
        Sat, 17 Oct 2026 08:07:31 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-183190aa3ebsm13170977c88.8.2026.10.17.08.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 08:07:31 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Sat, 17 Oct 2026 23:07:13 +0800
Subject: [PATCH v2 2/2] selftests/mm: load xfs before checking for it in
 run_vmtests.sh
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261017-bug-selftests-mm-run-vmtests-xfs-modprobe-v2-2-cbb36b014322@gmail.com>
References: <20261017-bug-selftests-mm-run-vmtests-xfs-modprobe-v2-0-cbb36b014322@gmail.com>
In-Reply-To: <20261017-bug-selftests-mm-run-vmtests-xfs-modprobe-v2-0-cbb36b014322@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 04CD2180006
X-Rspamd-Server: rspam08
X-Stat-Signature: adacny6dx8nb3mkrygkebudas5dj4h5z
X-HE-Tag: 1792249652-489389
X-HE-Meta: U2FsdGVkX19CsbzuKo+wPPwKgBjVbAwcEMd4corm064VxINAOcyI9rdMRXX16j13NKYMu/GNk3iYxCggDEzQE6ygNgWJyqA3iTrAuIgRcL4ilz8L1sS99faRKlzx2fNVD3aZ9xYtWbWe6SGvI2mzgskCqDWBMXBwyszVGIbI6suXbRUeszn9cACNlNlQevmjl75tpRsbH2s91LFXnnN0vL0i7L7RqaQpnZ/pMTagyq9F8BKd0jUxLePR7RFUIgqRZwDVvcZFQ6MtLt3+qvNGT0Gh4Xhlw/g3QxZXVMwgIkL0PN1iuFMxlGF98YVZ6PHxP/k3Kp6gH2tsVXsRpUN+tRtj6nicfIKFq4YOdVutFUkUdNDDqPbbcMiLz4rmKwfR6F5iF9qHvOP93b5YDLTN4SNG/xHFDsFx47nYxfr6NUO78sqQFqk1Fi+IbFMbsKttddm9ZyX+TthE9m7gXrvHD1CJqDS9r2siuHc5ZoPOXzreIAoZMRhkIMeM45S31SMJ6DC1D4y99cbD37B3HSpDZ1jY+/RwqKK5byBJGHlv5FLf5m/erQGPjSCEqE1rn5Ml/L7be0cEEumsuX6xuL6VGSodK6/MkS0SzkOQY24jAYHU3UgQxorUcgnz4YcP0jtz+n6y6eJuxfWgaW51IeRjcDBz5xC8VdNgvM9B8ZLX6plNubjm+TO8pwXVyMYi/LpJZ0puhgWM85zCpaD3dXw4BHy6A7CKJz6JZWgXsgzmyJ1mJkUm86/8aNpMuWrEPEloEtgG8tjGdJUuyI52AUDVqTVlqbM8lXgv4K8u66zPBGtCbR1z1DBNe5ZGZ0y+rnRXe2u83KlqkwOq4Im2mYpOxOKRw1zvacOOxdMWNk+uUXu5b+nz3nAnGscLOOdAzNcPP/76kC2mZtV1b7CpaRbKvKdNX/K5s9qaDIP0sUxJBtWbXNNvT1UaCSk2HPSNimBdebMPGKsATDLdBDjB1ao
 g0KPqR5j
 HEm6DEWWRiRLWa1AtQLJ8wk3PDOBvyvIuwXZQ0NV5G4GmOlzT3AfGzdc5HF92eMh9rvuNMgduKvPNuOVqOHu7YI+RRb9PpEYGq2Dx/60a+9LwG5aa9dSkgZJO8cqiQhIxdnBxyrDM0Ya7+aEo4S0uZSUp+thtR/VgWuCHZmd8696U8HUV4d4t+5AM7YhNdmLfWD6CgdnoKyCJnKWC5vbYlIGuynJbtNZ/0k6Jys73SCLSHf1Ec7Ez/xtc3HMwLvTpzAfHY56WRf8kp/4Ho8bRRE5Xm09FRYKSHkDLmqTCVq4XQ9p9Yuqo3xPENXZvPYE7TS+13B+2j6frgnC5oxwJXGALjLu5R7MR5SoHd4W0nQsSmjdz8wPjXN+Hbx0jEwLsuTixJbSZyw5j40SCudcb9y6waRd3SChQhHhJPq6jKsJkK49Uscmb4By3Ywp9mq7+w5lSB3EB2aM8At1BBdB0oLY6ShwrV+NDG8W8nGHhhahLo4Pvq7rH4EGzmWd5RlpK/KqGTGA0UGB+gC239ALSZN3ce7mAOa3HiKTBdN8K9nsFDKo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

run_vmtests.sh creates a loop-mounted XFS for "khugepaged all:file" and
for the pagecache folio split cases of split_huge_page_test, since
tmpfs does not give them large pagecache folios.

It only does so when xfs already shows up in /proc/filesystems. When
xfs is built as a module that is not loaded yet, the check fails, no
XFS is created, "khugepaged all:file" is reported as skipped and every
pagecache folio split case of split_huge_page_test is skipped with "No
large pagecache folio generated".

Load xfs with load_module() when it is not registered yet, so that it
is unloaded again once the script is done. "run_vmtests.sh -t thp" with
xfs built as a module and not loaded:

                                   before    after
  skipped tests                         1        0
  skipped split_huge_page_test cases   43        0
  xfs loaded after the run             no       no

Fixes: fc4d182316bd ("mm: huge_memory: enable debugfs to split huge pages to any order")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 56f5416681da7..ba77fae5df4f2 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -428,7 +428,7 @@ CATEGORY="thp" run_test ./khugepaged -c 4 mthp_khugepaged:anon
 # Try to create XFS if not provided
 if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
     if test_selected "thp"; then
-	if grep xfs /proc/filesystems &>/dev/null; then
+	if grep -q xfs /proc/filesystems || load_module xfs; then
 	    XFS_IMG=$(mktemp /tmp/xfs_img_XXXXXX)
 	    SPLIT_HUGE_PAGE_TEST_XFS_PATH=$(mktemp -d /tmp/xfs_dir_XXXXXX)
 	    truncate -s 314572800 ${XFS_IMG}

-- 
2.43.0


