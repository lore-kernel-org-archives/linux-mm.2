Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6CD6C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 01:08:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C9EC6B008C; Fri, 25 Sep 2026 21:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0C26B0096; Fri, 25 Sep 2026 21:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A75F6B0098; Fri, 25 Sep 2026 21:08:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30B456B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 21:08:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2740C078D
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 01:08:28 +0000 (UTC)
X-FDA: 85254127896.08.7E7637C
Received: from mail-pz2-f39.google.com (mail-pz2-f39.google.com [74.125.228.39])
	by imf11.hostedemail.com (Postfix) with ESMTP id D9A1940008
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 01:08:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="V7tPP/vq";
	spf=pass (imf11.hostedemail.com: domain of thehajime@gmail.com designates 74.125.228.39 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790384906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGJLJUYX098b2C/p5zUf0et0pH8c8hAZraf8w7dpmdQ=;
	b=A2veZ0LS96k0UJJv8a5q3yonhw0XPONYIvPgg8x8Sk2c5HpBtuUd1sKQYTxl2RGBkIGgzt
	vKe2o1XhbWhJO/UAp3I/rypWP4X7MDUPYTuNk947LOhqRkVMkcvfC0WMLrvFcvyljRbkNr
	q4RkXGIEwZStlmY27/5+CzQczjoBtK0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790384906;
	b=Cd929mBz05sOKUlQlHqi18TjMwoldY3OtWDXaV5xiFe/234eEUQqIpvUWd2vfAZ55saEAz
	seDNtNrDXde68f7u6r/8rd5mxcVEmOkEyTfbDB/19BOq2Iwvo6LUVUS0b4gHbR2sFdsNRN
	NgKe5FDolyhM3PK/iBisWHbQfqB4RmU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="V7tPP/vq";
	spf=pass (imf11.hostedemail.com: domain of thehajime@gmail.com designates 74.125.228.39 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f39.google.com with SMTP id 41be03b00d2f7-cc78e1a94b8so686609a12.0
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790384906; x=1790989706; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wGJLJUYX098b2C/p5zUf0et0pH8c8hAZraf8w7dpmdQ=;
        b=V7tPP/vqFHnnGUaaPbuNqW8+SfaN0tWLgBPqpWnWJvS79ETZuw5X3vHv8OHPC9oegE
         tgkNqvBO5ros4CB76YN5XYArbDwlR5Byfm6xt/VWoPtZU+xJrbIRsOU0Ucn4vvEExf53
         rfiQHkchk3N1LNVswj2mdYWbwHYInszlBQVT/3vKHxghQcILoy1vAk6ikRYDTToRz+Gr
         haMyJtj+VBlgzzTOK4DhUet1E83rfOiYO5ZJsI2SKwJ4tUpDlwrETGW8aVzp9klUihVO
         ge4XZhdE41Oq/PVHS7sL7JjyUT0jYKU0B+yY7LdaSTfGGsKM+tZ7bDwcYm0dFHvoq9Gq
         hxMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790384906; x=1790989706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wGJLJUYX098b2C/p5zUf0et0pH8c8hAZraf8w7dpmdQ=;
        b=gBSL36Oa04oJOOz+h3sgNwze40TrO2p5WS9/2nfkvxrbyLpfKddfmMmtvGR/qiPpQJ
         An+PkripADisgqtlmbIcDBngZc/labRJYVLlclgiWEjuAlgZW6/JjcB+8wDaRn6rqaRf
         IChZBVDzywbVg9br0bTpKGPICODPhFHPqxXEx8Zvt5B0CeLo6XElocfVIVEOB80C4hwO
         HZI/QFiGvvQAMS3nE7qCSogqxbk5GfWVvFqnZsvCtgLURAU6DFvmCLF20PYEEXOWqOAh
         /VspA0lGxORQPXWPCT+sArmudUUsvLdaZMEdagfXPTX/zfIFAxWgNqvYywIQOBGiL7/J
         4kpw==
X-Gm-Message-State: AFuF++mt0NsSeI7dQC8Gzp8svpfSOCNVgU2Imujs0fqvLwnbECnz7r7F
	z0J96j2lkxhVFPGYXsJL0U6wU29MMvsBf7T/RyPAlzJWQbPMUC+VHpyT
X-Gm-Gg: AYBFou250mtYA1wEFjwraBW+UiO2vZRAIrjJFAoQG/uWW+xBss48FeV96A3IR6wKViW
	8dP7SNg71jC+9dZIYYomTbklLzfl+DoqOUDVEKCW2fT7LOGkhdhR3rp57Zt8Nh6H2nLusBZUgVX
	WWhnJPfNKN8Agluu+qcbsuKbBatYafYfgcgTFZzcVaoZVpFw8+YcJU7HrZN4jmKxWIAAQ5uExif
	GKAp0pNPn68PXr6+/ZiTTQES7s+ug1I4eiLzZ6XdNet/9KCIcxddMzmA5jkmc2/n/pP52eLmEbR
	e9n9ne7JSx5i2zHrfLldAg7U3Fa8iO8FLOqzDu2aWGoV0Chl9YJz/twtovDtYtdEygCMPkgEdxH
	JAWJYhVUBrf75yIApbYcVGncJDxMK5X2gHyVE5tHc/F33X1PPYtu5BkBNPyKoB30xjgd7OwVaqQ
	QUr8KXTlHldu/muo9c1cjPTjbcAXL2Hy13dFIwQmlPAbJg0vjpwkp2JC8NT3vs+gIF5pm6RgglR
	t1MQ+3bUiiGAC0z7xpSstYHFbAncRqgM+vPMI2DJrhqa5HjfDX7eX2jars/df2hrj20jwa7UUgx
	Ulzt8T0HuIodkeUGBZfZ5cdAGMRSCoQ0K8Hmmi5Ytrnp5gfsfkBigDvD+JxXnA==
X-Received: by 2002:a17:90a:10cf:b0:3a0:b7b4:b649 with SMTP id 98e67ed59e1d1-3a0b7b4ba36mr2433638a91.52.1790384905575;
        Fri, 25 Sep 2026 18:08:25 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0974ec5dfsm13169486a91.3.2026.09.25.18.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 18:08:24 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id 99D8516C9C96; Sat, 26 Sep 2026 10:08:23 +0900 (JST)
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
Subject: [PATCH v3 1/3] selftests: kselftest: avoid cd - in runner
Date: Sat, 26 Sep 2026 10:08:17 +0900
Message-ID: <20260926010819.604346-2-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260926010819.604346-1-thehajime@gmail.com>
References: <20260926010819.604346-1-thehajime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D9A1940008
X-Stat-Signature: 49bxqmamzwp78yqgppq7hzyb3mumn3hp
X-HE-Tag: 1790384906-505183
X-HE-Meta: U2FsdGVkX19IZqKs253VtBNVi3vuc5+2SEwDNgesGZUcxzKVesxHNtkQQVIbnPTzSJMY7JVlwdEU2Cn/+XW0lDRFMGLZHy4PitJgFsJhwX2md+iEB8Ty8rilgNfPWvfH34fAdbtE3EexCIS7JQ/0eqvDaUYYo5XLgjAK3iyaeGdT+fpuwCBjGiMxXUJNNZ1cKjB5m7xfsZ8UYjHqWdV5ag2fqWoRhYfA90DGirgab2i/zPT+tIWQyBdkJBtGDT/q7XAiQEfFuymGRs80l9dcEj5eWXwNXKdYXYC1wWPe3ISEzgEsK2qVJUnzCOL90vze5ef00M3napQo1bYDizFCOnYAx0vHMM1Mv1cGAhkdph9stuXdIwhpVE//JigmHX80ayytN1+z9CtixYsBsdag/H5C0RPiARgQaWzfLTYWjTRt6NY7WNfqvydqjB8X2PB2bW9IKwRChD8FQkp5klhMXscZn5GoqlAvlVzpTcJTTex1fm0W2hFAr/QyzNmREOm6Lc4tDCPLvaRyIZwpHtWBqtHw50PfhQOtU3wSeQz8eHrYXJwnTMrK5S3Wz/Dq0ZHRjuBLfx9LcCgkTlZ/D0lzDZxOYeed/Jjq53wXP9jEKgQETrinN7DdOXqdudqrGvB5D8H6p4kIJ9Kb9PJHbMB+7hFwF4vYSDwfe4z8gQleKwjrFD5PeK81P1shwQ2std4bii+0VGM+k6gJluZgDtY3Msba9ID89hNCiYYWdyTeND/LUfdJdoyInsMkRMcW6qLxr2BUZ/xaHlj41N6fHhXw2FRzNGvzN/D775BpHFBQbNRl7jwQbB2v+pIpI4DI5ybswCdybUghj3+LWgAl+tnqZQom1OnYvWjxp2i+RVK/jN5pY0nmoxu9c7ByZt8Z4yN/lxu8cNz+qs9WQFT48J7nDMv2Nlg3CL99gAtj0RZsiCuwtOWLxXrY/BR2yR7k8gM7N8A/H2hrYifKC9gkUvr
 rCn24REd
 n3iD2l/il0S+V8Tm82uAKC+YwIEGwapwWyf1JdtQcFGoh+GMI5d1bFvDjHpNSXLDC41XKYxO883HnsWVM4WRz39+IEuhaVoKbColl664VGC74qJgscyYTuY30SBJ85kZqOnZnCkoFZNlgxmTsg8vm1EcMICAJWVpVU/GU1oPXXZpqI1vXWQwWetxVyJdqoSFXNaWM+0UBt0EYdj/ECnWewq/weOqC/vvoXdoAjI0ipJBPaK+BOO6f/06XiSZoW1z3AzrdvgbezOPkur7ebhjEgeP8GgwiF0NtOodXhI73AaIyMYaWydrzb+0PdCdkFp1IUm+yynazX0XSkcuBxwrVIHbo8ecPTRSUTRD5yEaeJRxhAx6Z/E8HrWW7pOysce9J8bQEHWDOqqUc/W1N91fKWSxLezuHGYM0G39a2dppaKnx181h1DJ1onTXgnXMF+pJ3ljU2E9+QFbiA+J8ue/Uvb7KlVMT704RMdxp35NHBfR1coduqvkoVlFf6wAmw2UoXwgm3Ubw51TmK4FzfNvNBpdn0DkGYhwJOI1Y/Qde/vADaBL7y5qPaaLsRE/YLLmh2aX2GE9bWT3D1mT3uoj+mkahdpvjQ4oTYX92+VJib2REFaUY27wPjmXi/BkBhG2lwmwhgNwrc8jA3quOWeUMpjuPSENGxZ768RMjzNO8Km/NO3o2cAPZYRTxuu67JDhlJU72
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kselftest runner currently uses `cd -` to restore its working
directory after running a test.

This is not supported by the minimal BusyBox hush shell used by some
NOMMU targets. Store the original directory explicitly and restore it
with a quoted path instead.

This also avoids printing the directory change performed by `cd -` and
handles paths containing whitespace correctly.

Cc: Shuah Khan <shuah@kernel.org>
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
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
---
 tools/testing/selftests/kselftest/runner.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kselftest/runner.sh b/tools/testing/selftests/kselftest/runner.sh
index 311811dc55a0..8fc1018d6fec 100644
--- a/tools/testing/selftests/kselftest/runner.sh
+++ b/tools/testing/selftests/kselftest/runner.sh
@@ -130,6 +130,7 @@ run_one()
 				return $KSFT_FAIL
 			fi
 		fi
+		OLDDIR=$(pwd)
 		cd `dirname $TEST` > /dev/null
 		(((( tap_timeout "$cmd" 2>&1; echo $? >&3) |
 			tap_prefix >&4) 3>&1) |
@@ -147,7 +148,7 @@ run_one()
 		*)
 			ktap_test_fail "$TEST_HDR_MSG # exit=$rc";;
 		esac
-		cd - >/dev/null
+		cd "$OLDDIR" >/dev/null
 	fi
 
 	return $rc
-- 
2.43.0


