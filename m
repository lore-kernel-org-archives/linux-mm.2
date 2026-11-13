Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE80C606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 07:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=CjeDckG5
Received: by kanga.kvack.org (Postfix)
	id BAE0D6B05D3; Fri, 13 Nov 2026 02:13:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5EFA6B05D5; Fri, 13 Nov 2026 02:13:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50DE6B05D7; Fri, 13 Nov 2026 02:13:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80B976B05D3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:13:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 09CE41606A3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:13:22 +0000 (UTC)
X-FDA: 85429229844.27.B21B461
Received: from cmccmta8.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by imf05.hostedemail.com (Postfix) with ESMTP id C72A3100005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:13:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=CjeDckG5;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com;
	spf=pass (imf05.hostedemail.com: domain of zhangchujun@cmss.chinamobile.com designates 111.22.67.151 as permitted sender) smtp.mailfrom=zhangchujun@cmss.chinamobile.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794554000;
	b=3ZXQXppVSH6XoOMlDY6+ZDqP6C2DaV1Qop+f68KgUDC21Rm7nIESjZZyte/4BWUmz+wOyB
	oeH2GKgoq0jyKuAjRSmqRExTiQYbcOpFJmVUO07LMIc3JgSP+FvqUVV48qzUoMwxlrJKyb
	DqZ3vS80VhD+++m1ZzFYaVi/6+KjUCI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794554000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jwJEcLepynHbIn+FVTxG6lhSdNiQ07QILHBvbeYHS+M=;
	b=U3VMpdm9Ub9LDRbo0ZhgX09DiZosPKQYr32sfvMtThox1wbIonb3S9UoGi4HX8ebs77sD+
	C7Fnm10+ytwtqEdTyFh4A1lwOv6gl6mg4wpRMxt3dpAbGE7X0kDPny2Z6MxQN/8f67ZYQi
	8NwcuwYPshK9+M59fstLux8xvyIP1oU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=CjeDckG5;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com;
	spf=pass (imf05.hostedemail.com: domain of zhangchujun@cmss.chinamobile.com designates 111.22.67.151 as permitted sender) smtp.mailfrom=zhangchujun@cmss.chinamobile.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=CjeDckG5BJvVoZ+/d3qltobSl8QLrmOl9wvuXOj8dcFS6OjanaLVI5FxRAmioaXnIvQZMgOa+Jwo+
	 ILVhlL4FjNplNBMz9rgAxjV7vmjkkdN8XvRym4rsFF364bTdRmclhMj1gpoTAOSB8OLr4ZGfFmrAR+
	 swCzb+7S68Gtk9to=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee26af6b8852d9-252a6;
	Fri, 13 Nov 2026 15:13:11 +0800 (CST)
X-RM-TRANSID:2ee26af6b8852d9-252a6
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from desktop-eb75daa8a6be458c-20260816004526035 (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr07-12007 (RichMail) with SMTP id 2ee76af6b883592-1bdcd;
	Fri, 13 Nov 2026 15:13:11 +0800 (CST)
X-RM-TRANSID:2ee76af6b883592-1bdcd
From: zhangchujun <zhangchujun@cmss.chinamobile.com>
To: hughd@google.com,
	david@kernel.org
Cc: akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangchujun <zhangchujun@cmss.chinamobile.com>
Subject: [PATCH] selftests/memfd: close fd in sysctl helpers
Date: Fri, 13 Nov 2026 15:13:06 +0800
Message-ID: <20261113071306.1673-1-zhangchujun@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C72A3100005
X-Rspamd-Server: rspam12
X-Stat-Signature: dqr8ikd7heqhspigjty36bycc7m4rqhe
X-Rspam-User:
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794553996-843996
X-HE-Meta: U2FsdGVkX1+MwpxY4JKr55c77A1cqAZM8QiiLh0BkGeFIi7jCECsk3oV0v7ywno5zcea8NnnzD2sr5zrFyaJwUIyAkk7aBudslEzA1Z6gHrOFRjlMSi6JeXDnQw/LXowKQE33QKrRpoNPSLsuvxMx8/zjoRgX+hgAmoCbjC91n3x+7jEJyIC5pER5/jPkj5i9+Y5rKAmMGMRPsilczaNYKZIJUkbjpprH5gDKP46iMxCD+TIg0/ysFY20EC57PFVEErYIkiVDPGunK/rIUL2Xz8QiExA3Iirmyda8kIIwlLq9cIthhg+WeT5DkctvxTK9HzMYL6m10A4wBRXrXQgLNwWeG7BleWmII2/vdpB59omhg6nfskXwx4ycOeUXlYAhwaLS4g37wNIEG6DL1iR3R78qJuClWzIi0lS+/TVIQ5tS9BhLFdp/NIJprReD1lAxAIROC9Me/ekQB0rdsm7gCEfE/23b0K4rK4h8Af6mPa72udhCklQFqQMdaxovJSo5noz4UL23PbNyJM/lupSjdH6BgkrpYSkm3VVLRE6S9E2kd6YnjaV+D+SwQN+eAbTO9NcdQQZIyT0wwfaf5YnOr6JS+MeDYEyTmEaNcV9hZTQNCYvuVACt7zotT9dvtlrMXvnntRh3ZuGFrvYWp0Q1mhBNp+1eokFqbHFGe2GONKrnzMwT80qGfJLTemiHrCDTt2sSHcpMcYaTehF/NT6guiUMHNARZ7BApPeyd/K8+Szb1zthUx6QxrxMldTBrc4l/jt5UcRnFpJz4ILmBJqxI0HZjTROmEl4aYPQBpr4B/73EEOdvGmlyfMSHK3gYAuJr01C6AcK4cZLoShBandU5ygG7OBZ/efSpDaGL/KxoZjCf8lwsqSEB31hxJEey6J21jpPK8f6HBq/n51hFnDanfx2oHPBrNiWNwUYrT0/QXxj8gbc3qSxOUpPz5rz3ygEyuygAGfK9ZvT2gp4Wt
 1It7szLo
 0ugrOh8aLuWObOpvaqycCkNM4EZLo3QPqd6CxpCfgp1Fl76V0WtNQhNcCoaGoeJzBPF8HLfb3AaWPM3is3lTLYiXtKmwQR6IvG1XzfGOHpbox3UNFPcNSTTmEWTorvAasjypW4IdKHAa7vTHM56Ozf6KresHI5+2i0Yuy5SqsOe9RkupOvhMhFWpKCWP3p61iHYg8ioMr7cPmw8Mgt87fOyxcsYFZAH/RVc0x5Uzt+mGDOuNnaUHrivOybQ8ODFFB0wafyQPYyFCDYHSsm5BPBsVkEOGhOQXWyA9rREUUYTepKtVDZZbLLHd5uB70+12Jf43cZRQcinPKr3g/0RWoysEHig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The three sysctl helpers sysctl_assert_write(), sysctl_fail_write()
and sysctl_assert_equal() open /proc/sys/vm/memfd_noexec but never
close the descriptor, leaking one fd on every call.  The noexec tests
call these helpers in a loop, so the test can run out of file
descriptors on a system with a low limit.

Close the fd before returning from each helper.

Signed-off-by: zhangchujun <zhangchujun@cmss.chinamobile.com>

diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
index cdab3a837624..8bdfa91d3b76 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -120,6 +120,8 @@ static void sysctl_assert_write(const char *val)
 		printf("write sysctl %s failed: %m\n", val);
 		abort();
 	}
+
+	close(fd);
 }
 
 static void sysctl_fail_write(const char *val)
@@ -136,6 +138,8 @@ static void sysctl_fail_write(const char *val)
 				val);
 		abort();
 	}
+
+	close(fd);
 }
 
 static void sysctl_assert_equal(const char *val)
@@ -153,6 +157,8 @@ static void sysctl_assert_equal(const char *val)
 		abort();
 	}
 
+	close(fd);
+
 	/* Strip trailing whitespace. */
 	p = buf;
 	while (!isspace(*p))
-- 
2.50.1.windows.1




