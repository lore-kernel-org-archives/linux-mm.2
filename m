Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF25FCCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 15:07:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFF8A6B008A; Sat, 17 Oct 2026 11:07:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAF2B6B008C; Sat, 17 Oct 2026 11:07:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EBEF6B0092; Sat, 17 Oct 2026 11:07:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 774D66B008A
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 11:07:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 821BB1402F7
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 15:07:27 +0000 (UTC)
X-FDA: 85332446934.06.A32162D
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9E8F1A0004
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 15:07:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YVBdb94M;
	spf=pass (imf25.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792249645;
	b=CsnFY4cDlpulbVGqRx5KHDEX5rTV+4oryFN0rfnCjjnnV2VoPIY1DeaXuMJynCBck+V+Kc
	CLhUnVcRrEEqtFzH/imp1/mGPY4oV6uE2Hjyras5Kk4Tm5eRI4SAs9H9TEnI/R783eLpSn
	hkP5T8X2PthePPXkPlhWvK0/UlrvbuE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YVBdb94M;
	spf=pass (imf25.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792249645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QiCRhwHnJeO8E2bgX4UvDZxJcOrRqOmEG3KFmXJoYDM=;
	b=VWOvkN9QgWMbnJMVzIybicY4YaVT2d1yLlJMYRkeROgF81dWJMzYYWRrThzc+ftfYW47tu
	tUYVLaW/RZhDCh57lK95cs6Ish17vfXGACYroEN4VxjSXi1+tLk6qMAfAM97DX5P1irkCs
	AJOC+v5TO+9qIGJqqKRDAtekXit2zjY=
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-35f036b17easo798722eec.1
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 08:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792249644; x=1792854444; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QiCRhwHnJeO8E2bgX4UvDZxJcOrRqOmEG3KFmXJoYDM=;
        b=YVBdb94MQpqsAklN9+sp0XlWIAsh/5PWJ1LJFgmD6bjD2pkXdbsPm1hCMVyY3hiWnJ
         GHUB4ECy3ipUh/DRE1cXkLbOnd0eWxDaBfzFAAI4BFkeXaF4bcbuPFwhzH4waFIVfGs+
         hFWuiRiq66NVUjuENpiSQaqHCuuEA4Iyz5sSw78up1tBr58BvsA4tTu8ygYw0GXIHrPM
         v6fFo+Z4zxiXv5jskDYFWL2zZxTRaYinqmKlqFpaOyLOeKzSfPW4hi8bo8nP4rykKoE2
         AETLxcAkauWKUdztzoLuerdoWUK6eqZOOD12hLw/U8nuQNKmEKPyLSIhpf5z8GJkZJ/i
         dEkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792249644; x=1792854444;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QiCRhwHnJeO8E2bgX4UvDZxJcOrRqOmEG3KFmXJoYDM=;
        b=PwWvTXVhuQDa9SxEd616VtXQ9Er1UQHWc5psK5ykgC5W5lwIBSY3YpOXTlP8arT5iO
         AjBHgFVmIP+c5noX54t6WvgXux9g/uEqB7CVXMc3W7EzGTzxOaiEaAr+qHyCNL6dOLDn
         TNFcdTrZlqzUNsdILONFQ61f88BpNAOe1g7vn+7NSvCtQk4P8qvkg2NBXIhCQWr0B1rY
         mHlRWG6rMSDq+teNyUMe1BdKeYtJKVSEVlH2aRTf/dCZBizEQE+dAmps/HlfpDzjdEiD
         kdAEHHPGDd/Js+CFDa/zLwnuJLTPIcyMHLXWDSa9FkqrDkMH6qBStYTVF8bQf8OWzBjq
         Gl1A==
X-Gm-Message-State: AFq9FYIaCwfgYyVLJcj/VGIHJyvdSSpT5lGUMiOYMqmZvC2uCoUI5uwd
	Ad7piMqiVFEMrBYo0T3OFFq+ge5pH0n4xrQtOeCBDcAtlYSLz9CXfLj5qVVivU6b8vc=
X-Gm-Gg: AYBFou2ySCDol/q1XPf7jlJTxQaHJNMVHyml9Zta34JWyRJb2h7tgybGPbLus0OBHHM
	w6HUezGWAO3SiejuEiUQpBLtv5UmXNiCWLp/NP9KiprGgDZUIJx4/85nw9CH4ozuRf6ITJ9C39I
	qx3aLUQm0hFhNFB/MujDCNQRFgJVn7LUseuCH8PNX/9BY8uyhr3+n86EfxGrmljeJ7Lku7kgoru
	39LyKhd4h3BoXcvKO3ImuFXgiorgdRyK/bpTeNX0aaNIllbTUiqjXZs98yq+2e6yfyI8s6Fp7/n
	uaq+FCGLYr+ZN2g0QtRvTd1Y4CBFcm+utZDUW4XDDse702v6hecvI1wEa2RgQ1H4fKu4vpeGy5z
	nqGkVfvpVjel9JQg52rDsYvK19MDGRABTESHvjKWCWbymne/6Gb4ifQw21C6AdjiIRwg4KvyVbq
	C8dk4kTV/Wxx4DWYfje/KV4/frF3VoNaQb5Snbis8nSD2xSVcrceZCGO5uwuXQpMsc9w==
X-Received: by 2002:a05:7023:a5b:10b0:165:aced:1fde with SMTP id a92af1059eb24-185079fd5b8mr4343118c88.0.1792249644367;
        Sat, 17 Oct 2026 08:07:24 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-183190aa3ebsm13170977c88.8.2026.10.17.08.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 08:07:23 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Sat, 17 Oct 2026 23:07:12 +0800
Subject: [PATCH v2 1/2] selftests/mm: track the modules run_vmtests.sh
 loads
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261017-bug-selftests-mm-run-vmtests-xfs-modprobe-v2-1-cbb36b014322@gmail.com>
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9E8F1A0004
X-Stat-Signature: rn443wyft98jporkpa9d6fn37sekq47p
X-Rspam-User: 
X-HE-Tag: 1792249645-638329
X-HE-Meta: U2FsdGVkX1/g1e6ceTflzzLqCFBLHqmIhAMEzx5eOc0YOfMlBHYhzQSUIFb2pZFAAPp6C4AMjvwvZFhP/x8d6S3Xi3yt6Au2tnGZqoTJUZm7Xa6Wk4/zU1YlFpzN2RiJGd47DpCfEBc/uP55qCJ85yE/ivEtcb7lQ/cBQ+jTAUZ/N7Nt+SPeAMVc3twfItzjmyH+LdZy8lAlyLjnjOOjfWqEvYmn3eYiKvVzjvhmy8nH+rTm81B2Cdgz50XB9JKpYa0NNzOms4QlkKnlUwwAZnluU8Zh5R8KkMa0K6tVzSzoF+x8MHfH/HfOf88wigHt4ljZvv1rBafMgw+Qs0Ui6O3FkSgYaajevojPPxfhsDMaGZ9Sci9tKoQQiZzqiEFNmU7Ruex2lCMhZ6Oi25B0WfACIR4XyBfRCi4c/C8bYl5iXCbTdWhQtf3437tA9L3YMLl+gzk0QfqMxa7tbBQKFU297/DjdjRTjDclQZTvLaPgP3jLIlae8gQh2GkzRRDAoQqvtBEcdBvcw1cHbk64KcqDfQ8Dv8fieWUifhXH86XxsFt/1E6EWoxMQjS5sumcLkqlLxNBEjzj2zqWKB5b+vQChfZ21QA+d2roQcjLYHuwA7CnRRm4sk6T7l6WwdYPxiYwLYiHOutNP6x/WpJBBvDmbK+NDuHbiLsSDXOSPg+icyHyolAEISB7yvY1JwRGOo4ycNk0g+e7N113ufcjcEjczEheO3AS34cWWcDJnikvBZ+5nqPdIUKC75Q66FllO9Ux8x1434UXWLXgrFtPRUVOEadrg7DqkKcadPi/nWJ57QRPF8MAt5miw+lbdqi7rWZnU6Rjmw/4QZQy7ZVHliieCZN5fQl6wyLe0QCjLWRAJpClKs1zklPVN22sXP21qD2QoMwbapXmAXMI74zfdo0J2RBFZwjHOkkMQOsWl4Xe7ETpibCAf7Rh5/vU89Npe5aiRFcdFzMOPTC1bEj
 jQCHyesf
 BR2RJJVln6xj7eO5bwAKNdyQwgXBe9+/QsDORnGt3Omcfi0gUN9bsMh5le96Pdek8/lJPdBy0supG/JLEugoS+5w5HjJnG2Zs2O3OVvgEUrKtYW0d4SoZ8659VQ7oB/R1Fgeao5MWaIkQjxRwk/Rfok1GHRt6sgKuBr/4uYMMMo/KHYpoh5eurddJbDsF8IYMgiOABzOYW0GXszYxT4W5LuHWPKjd2RAwk8PxUXHpr1Fhy/KCOjoogVc7aumIpPHUm8y6xhQxQQSrMfeOYm3pbHNod19PpfEnZ+tFHffEpbOBekRPGpiJpp722+DhN41bRvSHme6K+qwWdzhdpkYiZSfatcKctUqtPS5xKsywuZI76g1tZeff5XPufcSHZ+wRetnJK7DK4VciHLazLTfjSDAQHCQZaXR2PfHeB21Pq9Ti5S7WWjnec3LFsqi6qWEKvfAgUblPWpMhVTEAxVfVir8+Fng92Tli9ga3ERpnIJda285iPL3itcwN600jBWJZe77DEMAnQSY7SPhAujFc3ofx0kZ7jIZDIYyizlTYgks88ok=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 tools/testing/selftests/mm/run_vmtests.sh | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d09f9f6a384ee..56f5416681da7 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -177,11 +177,30 @@ pretty_name() {
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
@@ -207,8 +226,7 @@ run_test() {
 						| tap_prefix
 					skip=1
 				else
-					modprobe hwpoison_inject > /dev/null 2>&1
-					LOADED_HWPOISON_INJECT_MOD=1
+					load_module hwpoison_inject
 					if [ ! -d "$HWPOISON_DIR" ]; then
 						echo "hwpoison debugfs interface not present" \
 							| tap_prefix
@@ -231,11 +249,6 @@ run_test() {
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
@@ -465,4 +478,6 @@ CATEGORY="memory-failure" run_test ./memory-failure
 echo "SUMMARY: PASS=${count_pass} SKIP=${count_skip} FAIL=${count_fail}" | tap_prefix
 echo "1..${count_total}" | tap_output
 
+unload_modules
+
 exit $exitcode

-- 
2.43.0


