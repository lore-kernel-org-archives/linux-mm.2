Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BB4ACA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 09:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF82C8E001A; Wed, 10 Sep 2025 05:31:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA89B8E0003; Wed, 10 Sep 2025 05:31:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71968E001A; Wed, 10 Sep 2025 05:31:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B122D8E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:31:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6F989160806
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:31:00 +0000 (UTC)
X-FDA: 83872821480.25.D39CB05
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 28FF6A0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:30:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dv2yqJi9;
	spf=pass (imf25.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757496658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2qzBA9zUbwBtQk09XBYRmyAB+zZC5CxWhnXgvnYd3No=;
	b=OAdrQFoZYSRR0J6lly65DzXZi8PIMCEqdsNZ79KuLoij1bHWrNA0ycdrPT8dcMoMgMG13b
	2ATzq/rf2cDRBZBRxFp9qpMxtzKWl6OZTMVNPx8mFWp5vemPTIjiN68qFzFvwj5rsDPAVs
	ZddTYyJdVjJGURN22PhygOng+ZMj5YQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dv2yqJi9;
	spf=pass (imf25.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757496658; a=rsa-sha256;
	cv=none;
	b=70raYIZuONnZCwvVHKn1iluqly+J/fj/MZUz0bORWMlOvF6LptPI/AVNGh7akuhEB0whfW
	hnqMatoxLtfocqkiV3KegaLHWNWHr0zXttmThDNmmbxuaVGOhKKdU23nsTXODIujYdVHrG
	Muj+9h1b9Z8auyjepn8btOgd6zhhn3M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757496657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2qzBA9zUbwBtQk09XBYRmyAB+zZC5CxWhnXgvnYd3No=;
	b=Dv2yqJi942FowpQOmu3XqRyUi1xrti1wMBTPqdX+jWmNG94Vx9e041wlZvwY1WYIcavgOj
	PcByyttr8ZHSK7PG85RJOB+QULd+kX9lbgJxWCMjfeCYHpKpZ8DYgrZyezXCGRW4QwxJLr
	rsQ8wLCp9803/CpmWEgKJeOZ7qRRQ+8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-247-fkoeBPaXNlmUVO371ZxqWw-1; Wed, 10 Sep 2025 05:30:55 -0400
X-MC-Unique: fkoeBPaXNlmUVO371ZxqWw-1
X-Mimecast-MFC-AGG-ID: fkoeBPaXNlmUVO371ZxqWw_1757496654
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3dbf3054ac4so3876963f8f.3
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:30:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757496654; x=1758101454;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2qzBA9zUbwBtQk09XBYRmyAB+zZC5CxWhnXgvnYd3No=;
        b=UFVVulM/iuK/8C2Zp07YRWJP3s1mW2i2ynr28Fmr4yggQi9hvbHJttlYlxp2ioZYjM
         Jxz4wnv0AzIFgzWlOvPrHrf+yukcbEIhll+h1BIx7VZCGabwqFjGikleYart+6XMkZrh
         lH6j/aP+SsAtJKXZr1nqVIr9uGUnv0Lg1RVT41uVe09md4u4cTZdVYrzZ1j9lRXAWkUo
         wU2U6AqkNjGjsOa6iZIYRJbsinMpoohnZvV8+PRc3A/vW+0HtdVpCjfYtOcjWkIr8zyr
         2JwrKo0EBzVVG/o9C3Dfdfi2bsJ+QM9I02GMAyhJn2Sg/4FbOdtYNTsITHs3CaPWyuov
         KgRQ==
X-Gm-Message-State: AOJu0Yzt2/dxhdfvDYxyIKrxxt9jVxyO3RBL1PRpXgpHiDEdoOf1n32J
	xxMxs36hSXkKcqlRVqtt7GcOauYRiQQtHcb78QvRwlYL0Ck+btXkiDNWHnmkrwLuuVC0mSMUAPx
	xKVNApSNtpEQgE7kYVi9yuMLP6oQIBprh/WZ8MFvIkAGQ2OGhUvto
X-Gm-Gg: ASbGncum4VQmX554typZoTqQ/KyqteyCu9cCXdBN0A/XEQmL5qADbEvgUqjC4J210P6
	kV+KSHtnoNUb+T8EXbdip//ewV69x18+mTY/BbGwm+HT1FWp5bVORQJoeDq4wsWgPutZFE91SHL
	SAwkrkmUfzScPJXh/nNp60slOtXx5d8+e6bXT21tijfLoKIa/eGLnpbSvOtfUaHv14rfI11amsu
	7/+Y0KrXDFnVHkFj3qaSMAu7FU0hzWYOfJQJnl07dgpHlHf70uZmGywW+cvpivi9F+QvplhAzdj
	cH7CaZzjcVRIw4YQpcyXMRLb6xRgzrA8LYcV3IDhgkYtzIpNjn9YWMQOOlfj5OPypyLdqQ1fjXs
	8DBCaCNic20Fok2CZY37JBDDH
X-Received: by 2002:adf:e611:0:b0:3e7:42aa:1b3 with SMTP id ffacd0b85a97d-3e742aa0327mr9054271f8f.27.1757496653828;
        Wed, 10 Sep 2025 02:30:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEi3IitV0wCKvn7oRCPMLTVb77zHfNWhPGpq1wNihRoL3dQO3S5kiGmSFpyN3gxcJUcHXYIQ==
X-Received: by 2002:adf:e611:0:b0:3e7:42aa:1b3 with SMTP id ffacd0b85a97d-3e742aa0327mr9054232f8f.27.1757496653393;
        Wed, 10 Sep 2025 02:30:53 -0700 (PDT)
Received: from localhost (p200300d82f179c00d650ab5f74c22175.dip0.t-ipconnect.de. [2003:d8:2f17:9c00:d650:ab5f:74c2:2175])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45df8247bdesm20861465e9.14.2025.09.10.02.30.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Sep 2025 02:30:52 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>
Subject: [PATCH v1] selftests/mm: gup_tests: option to GUP all pages in a single call
Date: Wed, 10 Sep 2025 11:30:51 +0200
Message-ID: <20250910093051.1693097-1-david@redhat.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vj0mqmAVINoyoNotlU07xcJmQHfpqtACoADaYDyzI0I_1757496654
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 28FF6A0005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 8ttyg7cg3ejkyi9bd39mqqsao7rzyq64
X-HE-Tag: 1757496658-718128
X-HE-Meta: U2FsdGVkX19s62+qzdxRNvHn7xkpaEPM1E76npmMv0HN35TlrFVtHbOxKnNLy0RsZ6/r0o/+K7KOLsU7haxDKf6Y5NQ9hdB9b/mzBp1ThsBLd34Vozj/LGhpqfTgPqzQn4kfthEH2lB3HPRc2om3drL2jniSuqfV2uCPhLHpTzPwFcge+9SHrLthJCBuib2GbrsDlH6/FvONctdauUlmpHKr5sJAgameJCWXUKI+HQlcG6be4khH7nyNGdyQ2YNXwyF8I3EmxbVv6/FmuVAgSb5NF5R5yrhnGrUnJ5ySy69M8Hw5DXHTblj+f/P+5m/XDM4bChcCYENJOxU8bLerDKh+bjSiEGgMhtFPNGLyevBllIIq1tXQf9zOXWNOfO9mHgf+aVN4YVlRZ+pJn4Ueur5zv+v1F0SLG7BewUdHZJK/GW1WNGhmR9mtoaLtqMK1RudyRH2CqVw1OVh/U8jfO92ngpAknV6LdciDkfGwO8ni7L4wDR2Oq3jIohA0E163lUAABMxs7xQInSc9iw6qk1NLhAb+HO97B4XUtCi+NFplYRX89vnsfOxNUm/U3zVA6bvvKnBnjFQyolpeaxk18SG9Mx312GvM4vXFuiciAohF6Vks7ZxNY0EXIysN0LPEhX0QyI9j/OuYx+/Y3cH9ZJzAWNeQFGbQ29W7OD1osmAbrM38Yemv/g+n9R85dXJUrmLF/+bkeI+YMOWMLZZFz/MEjrlRCD0x2JrM+rgsXtTQz5ewd91iLIx7cjXtZrVxOmldmkXusLBkG3Kk9MUQhtBYbEZj8rWZQ4QzBeFxqlTYY0Z2oV6SW5DY4nBa4JCcocubpqX5bSQPJLJe3g9RccyypdgHMJscgGFfU9CwmvYs3HXmf4NOfgjaUIKX3f/vVjHE4+QMrlInrLf7pEH6LkPZXKEOKUzsXIbHAknovgK9PvXN7Kq28wdao/gJlgoqJpx15aw3+FwCrCznihs
 Z51PELIX
 hWF2oa7PzkBOr2ru2s+OxiTRThqupb8FBcqFVv7NuPEP5TNsEC4bdUPjoY9AMVLER21CQX1maCxFQrufUsu7Ett01tIHMULlkDmVEWi6HwVIZgUskKBnSJe+O/yPcvYQs9eYcLPNf7yZRhVs4mZJFCgbVEexZruV2IAopEoHtChZUA6GfnIdyahPyzK5hS20yM8RHRwbVZpkKiScO+YmDg9HKZlJ5Q0m5mEitxf2Kdgqb2ZKJi68jOmIpUDHftbYYjQ4ytz99d31qXxxiOTRhFHf1DW/4X/uZAxneUMc+vL1iYwiNR9yx/v0VUksEgLGIZ+ghkHbZB8VLdHlo9OWp8uKE3fH7MjFLE8xUFgouHr6TO7khHrxLes20MbygyG7qkpgKPMhdZN/hiWL8aQGhuF9p5ChBibi0PgwE9zeQFpEe9f1WJQ+KCy7q6Vyv1CwVHBCWmPuJlWFMXR18y9MZTO0nLnhld/trl1w5Ql5D6Th987OJDOZY5Gd4/Tlms3OytTZY7lYt9mur7FJKXOa1DnLWX6EoGhcsU3awVyCbfum8vfr/mSKYJ6oGpDgg2vfybZOrfhTQxnGKAFC+Bk7rlNgu5OdthPKFGIuw3kZrPcKD5Ybt1GZ6dFrHUshdPldNwVVKR2s5KjF98MPRf9hJSQeOZkz85CqAUhErhMJIm0nVzw4flaw2xVIOn4/bBRzETikJF1RuJR0UHcjc+WVTehOwpYIs4Is+u/O3Jhk6zjm6BfqT9QC13cptipqzRz351v9ad4pynMAZpKf1bbS6EuTbBeLE9VPb6dX3A3/RNiPnZCYxQGd/9jNCSGRznXFztE16F4jsFLxSenA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We recently missed detecting an issue during early testing because
the default (!all) tests would not trigger it and even when running
"all" tests it only would happen sometimes because of races.

So let's allow for an easy way to specify "GUP all pages in a single
call", extend the test matrix and extend our default (!all) tests.

By GUP'ing all pages in a single call, with the default size of 128MiB
we'll cover multiple leaf page tables / PMDs on architectures with sane
THP sizes.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 tools/testing/selftests/mm/gup_test.c     | 2 ++
 tools/testing/selftests/mm/run_vmtests.sh | 8 +++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
index bdeaac67ff9aa..8900b840c17a7 100644
--- a/tools/testing/selftests/mm/gup_test.c
+++ b/tools/testing/selftests/mm/gup_test.c
@@ -139,6 +139,8 @@ int main(int argc, char **argv)
 			break;
 		case 'n':
 			nr_pages = atoi(optarg);
+			if (nr_pages < 0)
+				nr_pages = size / psize();
 			break;
 		case 't':
 			thp = 1;
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 9e88cc25b9df2..6240e579b3ba5 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -138,7 +138,7 @@ run_gup_matrix() {
                     # -n: How many pages to fetch together?  512 is special
                     # because it's default thp size (or 2M on x86), 123 to
                     # just test partial gup when hit a huge in whatever form
-                    for num in "-n 1" "-n 512" "-n 123"; do
+                    for num in "-n 1" "-n 512" "-n 123" "-n -1"; do
                         CATEGORY="gup_test" run_test ./gup_test \
                                 $huge $test_cmd $write $share $num
                     done
@@ -313,9 +313,11 @@ if $RUN_ALL; then
     run_gup_matrix
 else
     # get_user_pages_fast() benchmark
-    CATEGORY="gup_test" run_test ./gup_test -u
+    CATEGORY="gup_test" run_test ./gup_test -u -n 1
+    CATEGORY="gup_test" run_test ./gup_test -u -n -1
     # pin_user_pages_fast() benchmark
-    CATEGORY="gup_test" run_test ./gup_test -a
+    CATEGORY="gup_test" run_test ./gup_test -a -n 1
+    CATEGORY="gup_test" run_test ./gup_test -a -n -1
 fi
 # Dump pages 0, 19, and 4096, using pin_user_pages:
 CATEGORY="gup_test" run_test ./gup_test -ct -F 0x1 0 19 0x1000
-- 
2.50.1


