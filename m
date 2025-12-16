Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6A3ED5E370
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 14:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C7066B008C; Tue, 16 Dec 2025 09:26:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626C76B0092; Tue, 16 Dec 2025 09:26:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5082B6B0093; Tue, 16 Dec 2025 09:26:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC106B008C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:26:48 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A55A605B8
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:26:48 +0000 (UTC)
X-FDA: 84225560496.16.0ACB351
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 71C3AC0013
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:26:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765895206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T48lCLSnQzaGh1E4jq9y/CPrfsm7qWaby5sNrBpmmbQ=;
	b=j19PjEOiCP/vybf3/QdLOGjZSgLOUyVFDg9Wz8r0jweIRJ679geoHOZCo5sH3U4VQ0FZtg
	6v1aAMXKfoCJuBvESONJncJotEobGhfRtCPmP3ooraQclaOhzyfRD1cBKKsV/2GtucEdKx
	CV0kQEURWj+wtSx/pIgtayi29b7f1ck=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765895206; a=rsa-sha256;
	cv=none;
	b=alQ1LVrwX7uppRPebnFEs9WNC7sZyJB8SeLc3MeOxINnuoFU+2Oe0YxMp/zCbeKBTGgN1j
	O6RDgt7q5daG8nW6Qil2+8l5BySiaetVCw7kYU02K/PE29WlfcZH1eDkPRfrmaDVIuAYjH
	Z8/unBXWMnhGZLEsdj8DgOGT9WurUeI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A11FFEC;
	Tue, 16 Dec 2025 06:26:38 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D20423F694;
	Tue, 16 Dec 2025 06:26:43 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH 2/4] selftests/mm: pass down full CC and CFLAGS to check_config.sh
Date: Tue, 16 Dec 2025 14:26:31 +0000
Message-ID: <20251216142633.2401447-3-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251216142633.2401447-1-kevin.brodsky@arm.com>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 71C3AC0013
X-Stat-Signature: fr4buahbncbccjeqt9pepsr8qrjomh6d
X-HE-Tag: 1765895206-655380
X-HE-Meta: U2FsdGVkX19S9hbSP0R4mNY3ar95tscMSAJrI13EJUPkiW6KUK0unSX0S/zg+2A7Mog38hixQige0IaLnP4NMyY4ecy2cdV6SMa6/yZUcL+cCOyeVl//yq4Vp+dKLkEsnIuj4vKIx8SjDtiK0f0uCn5kkZr4L1PWGV9H/B0K24cTdaHUfNg36GLwhCLmtfpe+kV7bealm706OFuUxNyc+pqkbBnKbRcWvj1CIEkT3h7B+cVZ2bXm+rvB9o9BKivOgRQ4yQrtNfGM6qAP/u40cUINySXKV+zEMC9HXd1VT42v6W94SaSPbge/szl29XuauzTEurLyYYOO9kfeE+21w7HD6ori+m/1XBpo7pZMpRcWvDbWN82w5oX7S4LZ9WVV1z3evWz+V5H1cJSlvNPdFQqY27OSL11YT1V9aCXjulKwwEbIboW/uirgdOTyt9yjoxe92/mxcbkNp0undzzoNDMLN7t1VQuYIhISq2iKRjEPwX28tegtdWadMHtUxX0c2avFQxKW5Y6trXkkwPmaibq+PGrces3N4DT/sQ9WYesLIcX1Ea3mKG8WbN8lBuqTTa9JxhmhfDndxlJwH5BfrrQT1xUBT4qde2ufQJkZcGhwqcMx4TAEgWxM+PLM3uug/XSk0wbvmIC/9LROTAtadoExzjbFD3Y4Xw0yfx1or4qmphXaXAVQYPv8z2uVlKHjpOVygH+a46n6kwLfKAys8T9hcWke6Uk4dqqKKSe1HwSqm3GbuKZ2B7hyry7fgQT/sVnKMROT/wpgjeDEHpJqnxBbuYIcCp48mM3gVhI7FyWHHBImSpwss9RUAEMLrnOj13lSCSYqRBNDXhPWiNDKdLn8yOoPfR1hFwQ2NyCOjqJa0Ae6vs+wnZ0ufdnUMKyg2D0heqIGUmpXCcSPgXv0VdRcT8g+A+AKoGyGYfdolNZ3uApduhR6q7v4cuT2LnSwQR0Upcugp1fKwsAoxU0
 5M0wi3gv
 buKRfNJj17aVj0+FWnHwUXKo2uVgbIBa/9BpBUAMez3rNKBaAqd03rqJwIDo5sEundzyMw7btKynw4wMpe6kFJrMZ1Kiu23M8CybeY9uciMaEuPyBnehX/E4y3GWtVEaU7nw9KtvgxVPqq/6Z/foIr7RbyjvuUTp44GqreVmcuwGiRoPZgSZ0WCaJA/rtC7Y/kGC/jF0UXHLKKaZDBJ9NOcl5oO6UM4xUBdo/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

check_config.sh checks that liburing is available by running the
compiler provided as its first argument. This makes two assumptions:

1. CC consists of only one word
2. No extra flag is required

Unfortunately, there are many situations where these assumptions
don't hold. For instance:

- When using Clang, CC consists of multiple words
- When cross-compiling, extra flags may be required to allow the
  compiler to find headers

Remove these assumptions by passing down CC and CFLAGS as-is from
the Makefile, so that the same command line is used as when actually
building the tests.

Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/Makefile        | 2 +-
 tools/testing/selftests/mm/check_config.sh | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index aba51fcac752..b1c949cd7c3d 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -230,7 +230,7 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
 $(OUTPUT)/rmap: LDLIBS += -lnuma
 
 local_config.mk local_config.h: check_config.sh
-	/bin/sh ./check_config.sh $(CC)
+	CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
 
 EXTRA_CLEAN += local_config.mk local_config.h
 
diff --git a/tools/testing/selftests/mm/check_config.sh b/tools/testing/selftests/mm/check_config.sh
index 3954f4746161..b84c82bbf875 100755
--- a/tools/testing/selftests/mm/check_config.sh
+++ b/tools/testing/selftests/mm/check_config.sh
@@ -16,8 +16,7 @@ echo "#include <sys/types.h>"        > $tmpfile_c
 echo "#include <liburing.h>"        >> $tmpfile_c
 echo "int func(void) { return 0; }" >> $tmpfile_c
 
-CC=${1:?"Usage: $0 <compiler> # example compiler: gcc"}
-$CC -c $tmpfile_c -o $tmpfile_o >/dev/null 2>&1
+$CC $CFLAGS -c $tmpfile_c -o $tmpfile_o
 
 if [ -f $tmpfile_o ]; then
     echo "#define LOCAL_CONFIG_HAVE_LIBURING 1"  > $OUTPUT_H_FILE
-- 
2.51.2


