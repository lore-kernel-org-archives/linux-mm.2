Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 788EC606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 06:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=h1jDri5X
Received: by kanga.kvack.org (Postfix)
	id 940446B00EF; Tue, 17 Nov 2026 01:32:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F11D6B05B0; Tue, 17 Nov 2026 01:32:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DFC36B05B1; Tue, 17 Nov 2026 01:32:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D10C6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:32:01 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B2FEB8039E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:32:00 +0000 (UTC)
X-FDA: 85443640800.08.2A83174
Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	by imf23.hostedemail.com (Postfix) with ESMTP id CC5CF140003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:31:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=h1jDri5X;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794897118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2gJeu9lz3FypG3Skb0xDHUuQAQkZLfZt0HTmDptUfys=;
	b=y2rZ2ZSNZa9WWSXGVG6zSYFEhLGYeoXyrmNeVdsNhes3F5NC7jwjKuoRkDaJP6HqV6BOoM
	jHDfTPdWCcJsq25t2fs1iRS8UhHJy4ODr6uiIlreLy+cC3PC1t5GUsmycRzNnm1zYU7skB
	wmsOBoPFCZF68AvK/zqnENXkx/ggP8U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794897118;
	b=Lp9E3Sk/GaI7sYF20X1jGuC4YDWxlfp8eOvnVvnRb4+7Z8LCyz1++JSWVD37bo63ulqZh9
	VZ5KrlnUg+M60/rssckrvKV+eN+HCPH7BKC2wf8ORecs6rkTL7t3F34/0Tv4qs8yEogA7k
	tmWv8yYXKRvzRcmqla71fgtYxmN9FqU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=h1jDri5X;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-pj2-f8.google.com with SMTP id d9443c01a7336-2e93d9c7973so28842405ad.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794897117; x=1795501917; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2gJeu9lz3FypG3Skb0xDHUuQAQkZLfZt0HTmDptUfys=;
        b=h1jDri5Xb3WtUqHT10wG1E6zndJ/L8+eu9iy71DlTeLt9z67PpqjcU4RJt4I/K2zFR
         CS9b5Y/1OAPqDJeWym4vN06YhbDrjRvVR19NsrMYhHCjqmZ6TBk6YlQntRLJJAcKjJ33
         tXII3tNYc9vM1C+S1RgONiNKlwfob+ww+rbYd5Xn80uuOIjjuK7Te4KP1n49qUu3NLnf
         /l8vYlMK0qZ3IQIHOKeCoS5c8R1ZOgA/9RBx0TNHRM2CwG1rMmgWbbh5ZwlGTpZcME3l
         pNfU3n1+lJtrwhJUqqD4lYcgfcNI99u3c0wm13/KQ06lCySlkgy8mwcY+4PzRTS4erod
         PlzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794897117; x=1795501917;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=2gJeu9lz3FypG3Skb0xDHUuQAQkZLfZt0HTmDptUfys=;
        b=THF0+9zuLYZA8MXKv996vZ3Wb7hPBYfzwCx1QDqfvM9DX5hWNWqLiNgDE/pjIwi1V0
         mOCKfWCYPa8SYhAUP611MKp+dASiUDbfW485c7UcyN1K1y7oJZVVJSSx59/z1bA3MJwh
         0NWLEah8kjtPMNmt2bST/1L3yj7X0RzOvBW2wKfOKXczlS+R/atAChGYUtujw6eaRSbk
         09egCTgtXtKePxwI5tDiyqbrdxRbM1VEIilUbLT8pLy6X+jQ/s0gToRg4elGO6F+xVEP
         CVhjV7BL+7eXVkrOSq+5Jm9FIn+9elZrvQPx5OF6CzF+bHQKKy3twBT5CVj6V0mdSKyH
         aIGw==
X-Forwarded-Encrypted: i=1; AL+hErG2VtCRKnyPddZcYGOFtjMudZuZmkdQ+zN3q3t49jP6osjp/BDOxJnofLpcee0R9E9rOogiDIfPnQ==@kvack.org
X-Gm-Message-State: APuU4Z+14AUHd3W5Iakttg0Bz9uQFitc9Oe5DBMa4JCRPmBTr01Cbo/z
	S8emsLkZUeMhMgd9/dHNjX4mvZr3gU9kn+POOlkkxSntSCSFBbrTaqX1
X-Gm-Gg: AYBFou1VihZALP3bxcsupVCD5TSRD5K7zLL4weI5mkFfDbw98L+ytoEZwiIoWR9A9/V
	J6d4ru57cAKQM+n1lfDhYWSEl9kLfiBMXobh88GQh/44JsRA73JdlnLbFs6a6YWO1Dh2xW2RWPd
	N1VYwBjB+bAsZwxcdGdLSZB7dYL3lrvaMYECewI5Tnalt3betCOuYmc8rpOYyw6uKcETXCXufOy
	tdpTQj0r3+xiddMCSp+EuIyUj6E3f3L7s/BpKgrXjkb6YbmStMi8qVbUi+aBtFQsvKKTI3jwwxz
	3ejorMkFWLp+mJtykbnHeRYEBIhdDMJOBcafUKskGoPbYzp+QpmO8m9TW+FyGSbdjeAp6DXumtf
	Lm2tXI0SNVoIiIN9dgKO94Ki+I/FUxIhjCV9z4fRkxcArG8gNHC61o9bvGXVjz45TYobU7vKtao
	9FQJmrAViZYR2WZ+B2rsQ9CY/nUUdvD209cei0+YhVY22oRil7G1rJkJYfcvuwkQu2C3IaGviR3
	QUqD9dRTBJ5M5TC2xaptvLmyFouy56B3lk/y08HrdA4iB7XMhM80SNfajV6Pb5rvfTjZkiiAFrL
	zn4bDR+SkxTSnhZhuBrsw0FLTipkMe58yDVASuAnFUOXDpiKV+d4JelaFY4QSoCys2ZFRYSPlbt
	kcCS2AuYWnKGpD5zjlweyzYZaEiHm8FQ8YzLoOUtwrlZmv3aPznyH3W1OiOrO6bM=
X-Received: by 2002:a17:903:988:b0:2ed:3e3d:f0ea with SMTP id d9443c01a7336-2ee0dd2bb4emr122131505ad.20.1794897117285;
        Mon, 16 Nov 2026 22:31:57 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2efd7a364f6sm8477105ad.27.2026.11.16.22.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 22:31:56 -0800 (PST)
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 17 Nov 2026 17:25:36 +1100
Subject: [PATCH] selftests/damon/damos_quota: skip the last sample when
 counting exceeds
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-fix-damon-quota-selftest-20261117-v1-1-c65d687d3def@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/z2NwQ7CIBBEf6XZsxsLMSX6K8YD0MViLChLrUnTf
 xds0uObzLxZgCl5Yrg0CyT6ePYxFBCHBuygw53Q94VBtrITQih0/ou9HmPA9xSzRqany8QZ94a
 ynVCmPTl7llA8r0Rl9P+43jbmyTzI5iquDaOZ0CQd7FCjTZ/nuDuP44iBZljXH36dM/OxAAAA
X-Change-ID: 20261117-fix-damon-quota-selftest-20261117-7c617b04fc92
To: SJ Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, 
 damon@lists.linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CC5CF140003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: u5twprxdhqj7rigu4e6zy4hkdrfhahb5
X-Rspam-User: 
X-HE-Tag: 1794897118-636327
X-HE-Meta: U2FsdGVkX1/kmYEYWi+sRamA69bjQx9r5bwWborgT9/g1GMy8HR46Ic+DNfRNbgjK3sG5ef1Ed1v8x5uMggq4/vVztwBuCWKOJrifV2CU4WAY5QmHrbQCx2TFt9ldcBqLQtZMDdu3jIbNZ5tk4ptmyCRE09PBhM7zduKYbS65p32i0+XwNms1U2n6xGJcYqlHcE4hN9Jfan7wZC0AvmLfQRFj2rq/qK8RlsFHVImHrzo3Ui9uy/IPfBTA1NRLan/fujwrQCM8JZl3sGRM3S4NrchcmVZMkGh+teYdfzbq+MYKEQcTIUpiXu2Pc83XAuqDbFDRtkKaa/0AAT8ZKuRSdT04qqrNTcgcLI6JDwJm/N5AyHR3el/9rc6jSc0fwL7/HqWoeu2WcSDY/2CNn7Wk2W+oF0EdUq4hWPKzUvMfqOVFn/7MtNjRfEQOTt8S/8RanFIziMsN50WO8rfQAZQmldOx0+AAwS/sAdR2UqJqx3ZVU+qZKaHa2c3fUA2qrDjC300q/nD4p/ky56cIlRtLawuOFXShPKk6zI/YKhTmIdVkULp5xNaId4+iLf7ft8osvwg18W5j6AGo2zWi8xpYUhwb0cBi1T+PpNmTwRuOe9PELJh+wK97GrsqDwS1nELQmks7WVBvk7Jmazuju/dS8QQSTXkKpzyyUbo/XOiHs/OfbaTyS5Fo9RvIHLQU7MKk9GYgGlncBgujXfaAz+htIcTFhpepO/leIQzvCMpwOeRE+ohP3ta1vs4vRtzj5+Ynpu7NiMPjWmgVk9Fc6w9IaFgWhTW/yK8tD3axkkL3NvQAetff8466vL34MpHQOoruiCtyUI8Wv5rAyO/t8GMu1XlvRr7vAi9pzduqVK0WjdKR5jR+Focz+D973I717ZUIZ4b6zfLzZly3vRXXllLfMxeLOdBt1OgLnR2wOBWrdlOD2bBgQ0D/Fmu4nhYZQh5xjL+Ie5LC2LrxNgDRor
 br6+3cdC
 Mx+MqbW3EBisaIO+lWrD9J8SHjcb5+y+paTJ+VJzCY4romPHxaxnzRi+2tCMiykdXNxDcm9zVqY+y5wH2Iy77W2zVCIKJ5aNTjMvb+JLe53Mf+UwNuAm/Xx8xLOHCjOkdRv+bgffAroy8xmF0VF39ldKCI0nVQPLjtdnHvsPGaoaA098zksistqAPvTGlqNRZQzh/cMu8/ZezLT9g4VCDsWfsoHH7mzUGozNRkIGnYfzRu/T6hZVos3TS6OrDke1GJ41eWD/KywwqAjLRUHM13dwYu/k5fYMFnZQbI4+RMGRlJJzoumz3aWVuOqdZo5xbNlAEOF/nxK7B8u2Pp2swcMlbBclAMJRi5G2aULObCPS8XRLXfWcSrYHrUOaT2kX0foR8BaqTVNcqCSsO1iWUnVGlI2p+0GhD5ul7H7AT2IwHQjzT5/5jKclTTH+gCPUXaYKPjMM7XIaz4QrDEpQmUkFSKWgdCV4rD+nN1Vq8G00Yk8vjOZdJXsu14q0XQNlquL9vlaZavEvJMvo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damos_quota.py expects qt_exceeds to be increased for every sample whose
tried_bytes equals the quota.  The kernel increases it only when the next
quota window starts, so the last full window may still be pending when
the workload exits.  The test then fails with an expected count one
higher than the actual one, e.g., 15 < 16.

Do not count the last sample.  Also drop the sorting of the samples, so
that the last one is the latest.

Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
Tested in x86-64 KVM guests.  damos_quota.py failed in every run before
this patch and passed in every run after it.
---
 tools/testing/selftests/damon/damos_quota.py | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/damon/damos_quota.py b/tools/testing/selftests/damon/damos_quota.py
index 879115a499bf..bdfd22f00079 100755
--- a/tools/testing/selftests/damon/damos_quota.py
+++ b/tools/testing/selftests/damon/damos_quota.py
@@ -53,15 +53,16 @@ def main():
         wss_collected.append(scheme.tried_bytes)
         nr_quota_exceeds = scheme.stats.qt_exceeds
 
-    wss_collected.sort()
     nr_expected_quota_exceeds = 0
-    for wss in wss_collected:
+    for idx, wss in enumerate(wss_collected):
         if wss > sz_quota:
             print('quota is not kept: %s > %s' % (wss, sz_quota))
             print('collected samples are as below')
             print('\n'.join(['%d' % wss for wss in wss_collected]))
             exit(1)
-        if wss == sz_quota:
+        # qt_exceeds is updated when the next quota window starts, so skip
+        # the last sample, whose window may still be pending.
+        if wss == sz_quota and idx < len(wss_collected) - 1:
             nr_expected_quota_exceeds += 1
 
     if nr_quota_exceeds < nr_expected_quota_exceeds:

---
base-commit: 67f3b04b277373438f17300e056306adbd9edf7b
change-id: 20261117-fix-damon-quota-selftest-20261117-7c617b04fc92

Best regards,
--  
Aveline Noir <jm5905938@gmail.com>


