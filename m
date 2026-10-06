Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC61FCA6004
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 08:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3569F6B008C; Tue,  6 Oct 2026 04:57:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32AF46B0092; Tue,  6 Oct 2026 04:57:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241376B0093; Tue,  6 Oct 2026 04:57:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C8A236B008C
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 04:56:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17B31A05BA
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 08:56:59 +0000 (UTC)
X-FDA: 85291596558.28.A2528CB
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4B20F40005
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 08:56:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aabd+HW0;
	spf=pass (imf07.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791277017;
	b=O6rs31hdVNjNBo/jXwfRRm26h2lAtdj52sGl9BN2ajxCdOw5DpyYd5qPPX2NcD1WRfxZF0
	3NYcdfnX1d7pKejUjAq5IKTAiy97DNAGh4BezvfP27nkO3M1fxEacWYeXhuCEkHWNGgtw8
	d8q7KOg+XxWSDy2BRYq4g+oklZHoey4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aabd+HW0;
	spf=pass (imf07.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791277017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZc7x+1xFrkceqpJwcgU1RKoagSWQzy1+YI5nAgqplo=;
	b=yBb7dMsAhjdm1DVreijtV6uhkYlAod+XhzfZr3Z1btWJT2sxq/RLt8Fb+ffBOxZX4LCBkC
	Xnv0+o2TzSMU53+i/GO0+v6e0AMKL2Py1PeR7xH4s1m5kgG7yETTYN5O+5uQv67ftbA+HT
	nTj0bN7SemGq8UwEzfslDQY5nYsoiB0=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3a4b3ac8fb7so179172a91.0
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 01:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791277016; x=1791881816; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PZc7x+1xFrkceqpJwcgU1RKoagSWQzy1+YI5nAgqplo=;
        b=aabd+HW00qCbGi13XkTZMfxlhs8kurXSHmaNSFmvsd6FZ4kPPsGFdzzi1x5+53ZKWS
         E2lh4LW5Mg1CEqNMDQwNHzev6JDJbTEaJZPlm/7Dtei8TNzWY32bqs0G/fIoS/K8fLIV
         2XShi1KrpkJ2LhjvuRVEJwCp4TC2fVkRfC/eRZHNR4QfAmemMacLG3RWQ8FPZw3HRh6/
         a+xt+KT09aO1kSV+13g5g3BPBTgikEEQmK+VC/PMS0WNqUBlPKGv4CpbN+fYCa8fVNPe
         oSCuw2jA3+bW4yoDuYJQCzWWaQX3yCfCuWye0VepR6uwBLXulM6wsEJ7d0WihU7wvgKB
         jhvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791277016; x=1791881816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PZc7x+1xFrkceqpJwcgU1RKoagSWQzy1+YI5nAgqplo=;
        b=ZdlU9J7L9uXvTP83nUBcOKyBH8jwI2XcWj0L591q4n0PjuZnJOGmDB9CNDyn6oC97R
         rPTTnShJhhgs8XKn7bNuVazlaFSNEnSoVG5bRD1Pi6Yl3mBwm3Ewd/Dn28Uf42hZItIk
         EexH1eo2DLe3t00JBkq0YvNn8KYmrJipr/ouBkDxY6VHz1G7HyRwqcf9W10BfoX+r8qx
         JMCpsA4oQoJigL//WNw9admIcdabgtK4hbj7ZN50/t7Ctyh0vrur7ngeL8RwW3aYjr7N
         DEdcghfG91+Nz4RaZAWapgX34tdo+izhXTZYN1bezQ4uK9vy7AXlUUr0X5PcjKqSg0og
         qtTQ==
X-Gm-Message-State: AFq9FYJeFE02F1Bdz6Kw/fX0vBoHQo8+YboZI98pHF9lb7s/9a+5CDqR
	oAMvl3/eFJDuqkxtd+ETHptd52qYDXisYOmhI3wJuulLleCoP+LnXeOu
X-Gm-Gg: AYBFou0sdgfWRBBZ+uchyDHcgv/mEsoByqR7lQhLgEgiMyrDemNJLCofOh7FOpPwWZD
	vZ/qyNdtlhk+W5SaKkvdqfWIx9NW1F72ryADTy32CzwL4sAHR+SZI8ZPJ0p25UCNoYLOyfDjtWO
	HJNWuN47XGohs0AbTmZQgw7UpYPC1Rg/V3SW+w+pcQausBnNhQNTmOuw2fw98GnMwM2f1NvqsXA
	ocl51Uz7SK8WRRsT4IXjRMgoiHvd+AWuyrTZsP7ycMjmVCZ6WVI+DohQDU7p/1DpeFOgflbobjb
	W6LjHW3gOItJOo7TPlQc1q83LU2IkY8p21ihku/pSDuM+3zre3q0Va9qxrvAmy1PMMGuRyzT6PJ
	gykXwXIpKN+GStLCn5WlSQaSJ3BdjuZD4FN+oyFP0unW15mcSN6loyXF0Jzixn/rNtaHfas9WEz
	pOzq+hCrG7ARrtjKwBy/YdXL/zYDEQ4f00scKWKR/0ur0rW0AZ3nFYSYU5xDiS1ELWKbV00H4+7
	LjK+TxJLvZtl/flugf2//eoExbrjBpJWt5lw1+JAfG9ulnAQKE3yB6v5FolumR9+9eWGP6Ril1k
	NJ187EOIcu0P2jCK6vKbw657pFpjYGvHOhDEcsNsuKeHjb3TywDrBd2W1j0kTcXaAobSN3EC
X-Received: by 2002:a17:90b:33d1:b0:3a7:cffb:8b96 with SMTP id 98e67ed59e1d1-3a8735173f6mr510245a91.18.1791277016147;
        Tue, 06 Oct 2026 01:56:56 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a853cde769sm3761921a91.13.2026.10.06.01.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 01:56:55 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id 4543816FBFD1; Tue,  6 Oct 2026 17:56:54 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: linux-mm@kvack.org,
	liam@infradead.org,
	rbm@suse.com,
	akpm@linux-foundation.org,
	luto@amacapital.net,
	brendan.jackman@linux.dev,
	david@kernel.org,
	liuhangbin@gmail.com,
	corbet@lwn.net,
	kees@kernel.org,
	ljs@kernel.org,
	broonie@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	wad@chromium.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org
Cc: geert@linux-m68k.org,
	daniel@thingy.jp,
	Hajime Tazaki <thehajime@gmail.com>
Subject: [PATCH v5 1/2] selftests: run tests on nommu architecture
Date: Tue,  6 Oct 2026 17:56:41 +0900
Message-ID: <20261006085642.3852152-2-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261006085642.3852152-1-thehajime@gmail.com>
References: <20261006085642.3852152-1-thehajime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q53f9fgybko9tt539tiskrnq5kqt5oz3
X-Rspamd-Queue-Id: 4B20F40005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791277017-717808
X-HE-Meta: U2FsdGVkX1+PFH/jN/QVSu+Let0NJFkzOAGVQpy9DX9h9j4W2RxFe2v3h7riGk3w0vA7+lNt/UzjUmoksrdkCjIp+Jkwe8sxKPXotIODBqWRX1SUwvhpZru2guSJIRactyqEVaCLIUL5A8RvzhL1F7hzjk1h3npffp5mFPhT1xPA1MjxzuEx0VpiI2V85Q88e9QyGBTPxYXjyu5ymm/MyDAEyiw7a7I39knExaYcOQXxbRn4ZAWHMZyUbnM/EUiYtJfHtXsysnrGKaq1zFFGUkCATzNu+zKG58MjQZNBXXGLPbXB2GcVWQiRWQ9EhVo8GLxzd1KnKODHLU03WWprUdSb6wZtl/CBFtNglyEXWZdfO5hAKv3j5WjQE6lnD1ZWp0W4MDTVr/Y8SyNGkYRydo5aK0Up/YPTut8n1daffpTndQn9iLktyU0LP0Me5OareM3VVQ0ZuwKCvmTJdx6pezYAvOJcVnTbsietfSU/i+yc+kgblSc+eYR4P7gxB+lBlqfJjTeRpMz4H3HrY7uS4jtnpPQFXVELxbwEaEMIH+6D76V+0+s1y74aGgGyV3Sriqsnf/g3ezPQGyzFiJP/ux23PCKCp0gpLlbic9nDQ2WaYl85hPZXbiB0rpBkFyVVBa3Oqy/m7QlxO/KV71XSAug8oAsqPkkbMfkm0uOtn4/RGkAfxqU85aZL62dbgdZyU1Q+fd4GJoWSXtK1kDKBISn7UgEgCiZTaWHwckZTCkoAh1aigifnVRWxmQapHNpUZjjr8K8OlhWBAKlm/Ax1GumbszhxDEgRmIFvGHjAIsshZnUp7gcfws/97gOO7oRgjiirENiaKoe/mj43jwp1I2SJ63UYprOFxGUIzNU4xQlwPpDKUvfolqar12iWjWZX+YG1xhaFbThrwLSxi+aUtHB/dDoxKlSMS1rMlsHrEY9kbCckJJeQQbK37je0QPvunLuguXFxftFInTjA/Dm
 g3ULjQz9
 1++i06g7kEuViV8vZFqtcaZIs4jptTD1dyJMEADxWvwoX/+UwXJOhNl7XtxuJOB7PbtBgIaUvIagnOiRFZ1qtSNg9tDO3YpWafPJgbMmfzLnvEpgmjAS1J3dzxSMj6Wp/of6EgpQEP5/LBe27mHT3ExzGRB2Q6wTQPna1JggpgIEq48W4lCkgvLFk3xyMoD8XdhCGtmgMGSLBvw80Y+WtwPyxWcEMX/hXbIyE9iAgSFREsSS8ll6Wk1BPMQssQFavtQZfuKdLZURP8UJZ2CLypYYSaLUWcz5GYZr6jyYoeNI1YXleakhbtc+wJ75LDowYqC9hn8rio8zJKp6UjldgI9V27UvEI0gt+Mss2VZgZ6tXIFXiycIS77rkftAlmWneesYDaXe9+H5l5CJDl7wR4kwarxZd1O30cS5y2KfiVnuLsXU3MIIm+8TxZMeFUExqnXDbGLY+9T0fzhDjyODAx3f13lRVO4xmhq7hR7X0I1b0Au6iT+a3h2Fk8feEz0/lkCIyJH1a9gVc2SP7DjKaba01RX7EBtbNGKlz0ED2hIOmm+XHWgLe1OKOpuiL8Qxg9rjvFx2ZNKPXCszz4dIr9JhHvhFT4CyVyPJAf/p2cv28squyUvvJm+jD2TS4OxSwZrVBjdugBwWk0wCfaeBV+fNathlxAll+TnzWW85xP56WWlzifXwh4gFkmWF8NwkzYiLrZhRZBLPx/J67xohGIFZApWk+C5o92y67hACXtoISkLqLaq8TW7gorcoeB6LujfszX9OfiYK2beV85oze0cmFam7hPLcl5x8/MlnWNZKg5Eb6+3g/VTSVQejgM5IwOZbMNuYvaWRZvl+wKai+rdLIHkYaEFLVCYISg+mhdESXYCDj/1ckNzVj9BKlO7A+iX5IpK6zVvTlQag=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Architectures lacking MMU don't support fork(2) syscall and only
vfork(2) is available with limitations.  Thus, we cannot run kselftest
on nommu architecture as is.

This commit addresses this issue with the following changes:

- Detect NOMMU at runtime from the MmapCopy field in /proc/meminfo
  and avoid timeout, which requires fork(2).
- Document how to build and run the NOMMU tests, including the procfs
  prerequisite for runtime detection.

Build and run the tests with:

 $ make ARCH=um O=build kselftest-all TARGETS=nommu
 $ make ARCH=um O=build kselftest-install TARGETS=nommu
 $ ./build/kselftest/kselftest_install/run_kselftest.sh -p -c nommu

Cc: Shuah Khan <shuah@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <kees@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Cc: "Ricardo B. Marliere" <rbm@suse.com>
Cc: linux-kselftest@vger.kernel.org
Cc: linux-um@lists.infradead.org
Cc: linux-mm@kvack.org
Cc: linux-doc@vger.kernel.org
Closes: https://sashiko.dev/#/patchset/20260813063401.1786548-1-thehajime%40gmail.com
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>

--

v4 => v5
- remove build-time selection and detect NOMMU at runtime

v3 => v4
- fix typos in commit message

v2 => v3
- remove unnecessary modification
- new target is moved from TARGETS=mm/nommu to TARGETS=nommu
- rename CONFIG_NOMMU to NOMMU to avoid confusion to kernel config

rfc => v2
- reformat ktap header, reported by Sashiko review
- https://lore.kernel.org/linux-mm/20260825015945.141739-2-thehajime@gmail.com/

rfc: https://lore.kernel.org/linux-mm/20260813063401.1786548-1-thehajime@gmail.com/
---
 Documentation/dev-tools/kselftest.rst       | 18 ++++++++++++++++++
 tools/testing/selftests/kselftest/runner.sh | 11 ++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/Documentation/dev-tools/kselftest.rst b/Documentation/dev-tools/kselftest.rst
index 64c0ec742..fc4dc1f9d 100644
--- a/Documentation/dev-tools/kselftest.rst
+++ b/Documentation/dev-tools/kselftest.rst
@@ -230,6 +230,24 @@ section::
 
 .. _tar's auto-compress: https://www.gnu.org/software/tar/manual/html_node/gzip.html#auto_002dcompress
 
+Build and test on nommu target
+==============================
+
+The nommu selftests detect NOMMU at runtime by checking for the ``MmapCopy``
+entry in ``/proc/meminfo``. Ensure procfs is mounted at ``/proc`` before
+building and running the tests.
+
+::
+
+  $ make ARCH=um O=build kselftest-all TARGETS=nommu  # <= build-only
+  $ make ARCH=um O=build kselftest-install TARGETS=nommu
+  $ ./build/kselftest/kselftest_install/run_kselftest.sh -p -c nommu
+
+The C tests report a skip if ``/proc/meminfo`` is unavailable. On a NOMMU
+system, the runner needs that file to avoid wrapping the tests in ``timeout``
+before they can report a skip. Mounting procfs is therefore a prerequisite
+for running this target through the kselftest runner.
+
 Contributing new tests
 ======================
 
diff --git a/tools/testing/selftests/kselftest/runner.sh b/tools/testing/selftests/kselftest/runner.sh
index 311811dc5..45fb8ec38 100644
--- a/tools/testing/selftests/kselftest/runner.sh
+++ b/tools/testing/selftests/kselftest/runner.sh
@@ -36,10 +36,19 @@ tap_prefix()
 	fi
 }
 
+is_nommu()
+{
+	grep -q '^MmapCopy:' /proc/meminfo 2>/dev/null
+}
+
 tap_timeout()
 {
+	# nommu doesn't support timeout command (missing fork(2))
+	if is_nommu; then
+		echo "timeout isn't supported for NOMMU"
+		$1
 	# Make sure tests will time out if utility is available.
-	if [ -x /usr/bin/timeout ] ; then
+	elif [ -x /usr/bin/timeout ]; then
 		/usr/bin/timeout --foreground "$kselftest_timeout" \
 			/usr/bin/timeout "$kselftest_timeout" $1
 	else
-- 
2.52.0


