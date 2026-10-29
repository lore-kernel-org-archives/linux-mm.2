Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 388B4606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zGQd4tkx
Received: by kanga.kvack.org (Postfix)
	id 4E5566B05B4; Thu, 29 Oct 2026 02:24:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496016B05B5; Thu, 29 Oct 2026 02:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35E726B05B6; Thu, 29 Oct 2026 02:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6576B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:24:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95336A0301
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:24:51 +0000 (UTC)
X-FDA: 85374675582.01.C97772F
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id C9B49180002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:24:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zGQd4tkx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793255089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PSKKrZBqxdz+n8H6S7Tg/WkVPzmvnVBSCNKmv7aM/z8=;
	b=g6qpIKK2ygoksigjGbVvNLLdSSIWb2TJ/WcMUb17ePlyiE0jgouMwho5VNPhwAfueEq7Ww
	iZusk5fCRnTnsvSu3OUaGHChQ3diGcEgMen83ZVyVYNoWjLDSjsOyaWykiAjh79fPA767T
	29NMA58zVNzUEW1EscQH3UyhbRC9rX8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zGQd4tkx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793255089;
	b=d0MG2kWW9lQXnQmniiWT2eXEK1d1MwxJwBKF0w4iKZw9lrLL7wH4BVjD2Evd+yNn1b8Tjz
	UFl2L8Uj23Ee7zOZwiGhrcea6J/IEUwy5lktVz/Wxqm7UG6QNEuhDC7+JML4pEu9JghzXs
	OHkuOsNji16fld6p0B9yiq02Zfjourw=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-36661f953e4so2896618eec.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793255088; x=1793859888; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PSKKrZBqxdz+n8H6S7Tg/WkVPzmvnVBSCNKmv7aM/z8=;
        b=zGQd4tkxcO7p9Y3ZwuJXg1ex5f0nAVvbt7s+W5i0HqrBcxCI081Y+P5QZh32/p025F
         nOLF1AW8g2HYD1Di7YZuUga6ek0Xs4JGjEIvAny6M6bwC+VriO+mOZu26Lyre4ImsRPX
         DjdjH7+VPXmLJVyY3aLJA0ed1KmeHQvJYuqOPH+pd5q1qe/lBx4M4wx1ZbvfAeD5+d/9
         4MpMW2c+dBD6UnsDX1taLWfbLx8xjgVU1qXn3uwKnNLKG9H62+iRM9Op7ZsWGuZDO0Ce
         rZO046544e3/aMkzo2phT7yhECozq6/eomJP+jw9ANXB97X82hMZIiVkhZp2tofPSHSZ
         xzlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793255088; x=1793859888;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PSKKrZBqxdz+n8H6S7Tg/WkVPzmvnVBSCNKmv7aM/z8=;
        b=MWTH0XXtSmxuQfR+aO1toDAZnOtaNIe3GDyVKzwDy/AmZu998em27VR8/XMYKmpctN
         FL6zEIZsoHkfLwJ19YO6isOrBWIPCPPDzVbsOjvlL8GrAeStKMiw9FT79dSfoqYgqSka
         FBK6/dHAultM5kHS+JcwvNfLndFWWy+yJEC191IqS4lTgp3BCIl9zzP8c7gZp8zlLoe/
         DRIzJiw6KsafyLfdV4E6xuGrkSLGPBV6ERD7O+NJWD43QQVlJznG3P2WSUM1anqiQltw
         fArYa3tbirouBVhhCpoZAKqSJBGcdOknY/V5WHNyG+up24A7XsB0UM+X+nhipDzrI129
         GSnQ==
X-Gm-Message-State: AFq9FYKfJcne67smxhrDrutABTEY2DDFcJ30j24970pTV+h4k5ICgqY6
	Yqgia6druUU6Mgc47NJfV7+WD9XxoZf+RAjpBfCG0mKJ2T9UVsKl9KN4
X-Gm-Gg: AYBFou0ZFNrYRHrkTL491jhx/8U33kW2aMGOIqpIKh41c909ZXPyqUIuzFNAPmHQzSy
	luznEwU0MX3Cncsdod2bk+NI5KxPDJRBqoQued8J6aiAk165RSc4hVKffXx+KmmwV/jKHdqYDER
	PJklvrkZuJIt4UEwN+iuPaWuRchjBrWscya6ZOp1kBG6Q7PpyOKJ7ORNQoa2myzgeE6gmnLBA/2
	YWZdW01/uhs8x9Xep87gfIx+8Sbrr2qZrzGqT57+S1vLx1c7pkDXpeoV4acVXLEJmTNZBOesjwh
	Xu9fSljnLBQlNWuYYsYnMsphWOBsl492NGqnI7ZHl5pTDKhl3oEzfQyaF105gUzW68VSfjXRWPl
	EKcFr56JCNB/pyL55M/EB14rp5O/Zd7hJWGc6ID51MdjDbUgpo06JPxdKbZqSlDiIgkeML2wXNt
	e3F1C0eZw9MmcUpK/FVfeT9EO2BEzEtqrjbArytoRC5527AYsB3gZZb4HBx4fK0tMj6fs7d+rxB
	H+PgvCVUatti02M6zeUwUqp3RCIYa8bP2atmFfJ7Bd5tu3dvTc6ZyXsZttBqzT2si6I7VlhGfih
	6OEa2P9aCYHOy5Gdscuv3N5ctw==
X-Received: by 2002:a05:7022:7f06:b0:1a8:ff0b:a4e1 with SMTP id a92af1059eb24-1a8ff0ba512mr2702485c88.18.1793255088321;
        Wed, 28 Oct 2026 23:24:48 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1aa2f100684sm2152004c88.3.2026.10.28.23.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 23:24:48 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Thu, 29 Oct 2026 02:24:35 -0400
Subject: [PATCH v3 1/2] selftests/mm: track the modules run_vmtests.sh
 loads
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-bug-selftests-mm-run-vmtests-xfs-modprobe-v3-1-16ad772850ee@gmail.com>
References: <20261029-bug-selftests-mm-run-vmtests-xfs-modprobe-v3-0-16ad772850ee@gmail.com>
In-Reply-To: <20261029-bug-selftests-mm-run-vmtests-xfs-modprobe-v3-0-16ad772850ee@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: C9B49180002
X-Stat-Signature: pz13szubccx8f5c8ftpr3ardhkwuyjp7
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793255089-740499
X-HE-Meta: U2FsdGVkX1+zQaWQXbA6ZTzn05OsgFEMp+sDh8Ajhvmt0lymsI3pmp0xl6gpblC6TAGYhKmJT7PGhyTMjpuoQ9ZyAN4xJZHeKjcxL16GTmOKx8UdXI5J8C7pV7Hf/WWB/0Y3988nXJNZh3v+6ibjbOdwEm4lL+ljgVJ0TeS4qaajUDYuuGKq/ZO3HuBgMIYG9SII3xyudo7v4PFRzoUtfoy7tcH6rxV0CXonMuMbXKoqQtArb539/jIlIMQgcVtNqnueCXnWEhrmHX3jGI9c2WLYt1KluzwAWoApKhcMn1zVkqpH7KeJtdtJYlrYYcWFFfGGgpdkfTnAusMWJjjL1g0bDLLPIJTkmi59XLxDOoN4XP283nWFCgiMhsTaz23dq54yWm0kSJc/3iGqSIKWlM4XdGQpPfvvAq9mf7+R3f6SMhFuS15LIP/yeSWWK7NYKu5BZuOZoT52aS9OqH1ba4tDXtuBhBH2Rj0pbHN2LOUgSwqETztBKZQ0zJUKnnZjeig+/RrUyI3uC4IIICAz/UDg+6S8GGrvv8FJuKKv195mryAzzXaVL3VPik1lg9vC+gCMoNUsWytfV7LaDIbpzqaHD8+RAboTY5OBRRmb2TaDiw3NrwmKT+jZ5c7YIWDn/cf0wSR7c9v90ywOmlp7rU8gh6HnHgTq9Qtn/GoREzOlbYpYVfzKAxJp9Bbha702fhGSE5YAH7QaV8AlI/1R1lOwXYISjU0NZdtHgx3QNeD4RuIKa15n2SqSzx8c8Q73io33oK2DPEqOiQHU9sn7hKLOGeaM0UC0ifkhLcXp33b7m333+VOlUFTZI0eJVgLC2/0p4u5/8ddJbaSxjk8Cp9Nb9vu2cJt3fjJboE14gCGBjnP40sWICFze8rI4cf+aWDZ9CT/kSF+EKVdda4z/K9YJFnmlumVdan9IG1BYZtvR19sCta58jy1yFbc8p1ZPSVJVqVsA3CVifjTvc9h
 /NrbTvsM
 Na5DCDHDVLpccF0VUOpr60PE3loyc6hOhQ+LlI96MgElNjtaYEQVeICiFKPAx4OkNVZuZ93c8kbT2sfImEOMTmFVj0RXgBPiYCS6N/oQWzGCfNW2LZJ8G6LbjtEQ+qI5WB3/uK5/KNVrwduPyWJuvv8I+bBF474EDnD1id4lqRpmx/WfIjhuQHDpBwflispPvYVu74cpV2AFtpX7QtoM2Q1VIzOA++NN72qIOBtJn+dlZKio3Xm5YbqTjQGPuiR2vbQG7o/PQVZmJ1hBJJr6W1JEtbFfnDGog0nfaLG7qAtqVtgSlBHfXUpatMujPIi6mYNeaawGnV3VLdwhA2NAin32upzuy213EqVjLwmDkxGm6JDEL/khbG6kqX4jxmWmBiSePvetnrs0d+NL1oqfPMay05TZFB7aluI50HubsV1+KUQNfuNW969oZLeuhK9TOoYHfhxb97QVirGo6nPGTsFfIsex7j8yNyKaHINiLUF4sMaFrpNPuQ8Zqqf1J1FvDTAlVLfbYz3Q5iJHnY/OG5E/hwooSRdjekPAi7WyPLiqDUe4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

run_vmtests.sh loads hwpoison_inject for the memory-failure test when it
is not there yet, remembers that in a variable local to run_test() and
unloads the module right after the test.

The thp tests need xfs loaded in the same way, and repeating the load,
the bookkeeping and the unload for every module that some test needs
does not scale.

Add load_module(), which loads a module unless it is already present
and records it, and unload every recorded module, in reverse order,
before the script exits. Use it for hwpoison_inject.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Tested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index a1b45a3dedaee..e104a9c6fdefb 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -171,11 +171,30 @@ pretty_name() {
 	echo "$*" | sed -e 's/^\(bash \)\?\.\///'
 }
 
+# Modules this script loaded, unloaded again before it exits
+LOADED_MODULES=()
+
+# Usage: load_module [module]
+load_module() {
+	if [ -d "/sys/module/$1" ]; then
+		return 0
+	fi
+	modprobe -q "$1" || return 1
+	LOADED_MODULES+=("$1")
+}
+
+unload_modules() {
+	local i
+
+	for (( i = ${#LOADED_MODULES[@]} - 1; i >= 0; i-- )); do
+		modprobe -r -q "${LOADED_MODULES[i]}"
+	done
+}
+
 # Usage: run_test [test binary] [arbitrary test arguments...]
 run_test() {
 	if test_selected ${CATEGORY}; then
 		local skip=0
-		local LOADED_HWPOISON_INJECT_MOD=0
 
 		# On memory constrainted systems some tests can fail to allocate hugepages.
 		# perform some cleanup before the test for a higher success rate.
@@ -201,8 +220,7 @@ run_test() {
 						| tap_prefix
 					skip=1
 				else
-					modprobe hwpoison_inject > /dev/null 2>&1
-					LOADED_HWPOISON_INJECT_MOD=1
+					load_module hwpoison_inject
 					if [ ! -d "$HWPOISON_DIR" ]; then
 						echo "hwpoison debugfs interface not present" \
 							| tap_prefix
@@ -225,11 +243,6 @@ run_test() {
 			local ret=${PIPESTATUS[0]}
 		fi
 
-		# Unload hwpoison_inject if we loaded it
-		if [ "${LOADED_HWPOISON_INJECT_MOD}" = "1" ]; then
-			modprobe -r hwpoison_inject > /dev/null 2>&1
-		fi
-
 		count_total=$(( count_total + 1 ))
 		if [ $ret -eq 0 ]; then
 			count_pass=$(( count_pass + 1 ))
@@ -453,4 +466,6 @@ CATEGORY="memory-failure" run_test ./memory-failure
 echo "SUMMARY: PASS=${count_pass} SKIP=${count_skip} FAIL=${count_fail}" | tap_prefix
 echo "1..${count_total}" | tap_output
 
+unload_modules
+
 exit $exitcode

-- 
2.43.0


