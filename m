Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F654606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=riHZ3V43
Received: by kanga.kvack.org (Postfix)
	id 131246B05B1; Wed, 11 Nov 2026 02:53:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1093B6B05B2; Wed, 11 Nov 2026 02:53:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01EAC6B05B3; Wed, 11 Nov 2026 02:53:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC96F6B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:53:02 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5508CC0234
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:53:02 +0000 (UTC)
X-FDA: 85422072204.17.DD9BB1F
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5CCDF20007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:53:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=riHZ3V43;
	spf=pass (imf03.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.173 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794383580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HqU3Pl0zqzkcuaNDEwB/Ax9fkH+ammw/qBuPNlSTruE=;
	b=uXRjLDv6nQ7wCCTXThdpkzd2WtS/+Kt4hKgxaINoIkLGghJj7SoSwIGYsAVQBdRj7Fikap
	V15W9lPtm2j2ycN9lJrir+Hzdj2rNG8EFWIeWyogsXGZzWn7/cnC3XUw3ygR4pLDBTE4HS
	oVElHrCLKktvqZCZ8tkZsBf8XXiE+5A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794383580;
	b=27Tc5Xo6OzFwN9zEQVrw60iM/R2j3QeHXXy/e2vNPw/1SFRsWXDGch+aKU6LpsgfMlC/hy
	SkfLCzUYi0oeIybzl4vHnxxE3H8111yPDvFocXK4AkEI1C4AtyXB0otLHio0PjkwRftI3s
	azwSLypSkLA+V3DfdX2ZRb5lnhPJUP4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=riHZ3V43;
	spf=pass (imf03.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.173 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8a052aff9e9so2277311b3a.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794383579; x=1794988379; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=HqU3Pl0zqzkcuaNDEwB/Ax9fkH+ammw/qBuPNlSTruE=;
        b=riHZ3V43JiPU+2sb5SWjxcsC7YLN//GfD25X0xeC63GpkJxKcvC3C1u28+Ax+9FsUT
         aFh1YdM/OA9j0qiATer1BkBU9XfH8+mUBLO0fcubVrm3BogyQk3/q0h47oRksL8TuCzh
         dY0eSUPOfXJbTIx/vGAjU6psT3faEyJVDGvkk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794383579; x=1794988379;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HqU3Pl0zqzkcuaNDEwB/Ax9fkH+ammw/qBuPNlSTruE=;
        b=jyhl0SBEcBDRtwE1/PpE9X+eIvgBHqm+xFefB0BIp80w/m62AX9WiwSqRw0TCUf7CL
         59HCJ+tN4fW8GGI42768QSV5tfzsPQLjvDxj50xLJ8ooXvkiRyLs4lel791v5tmfOHp/
         jGF9HQbGAsmck66uqiKxdpVfzDq4m7m3egv4V/s2c6ldYX/AaApEbBL69fXyuVPQ58NU
         BzKFNqVuq//zuaFNEihe7qUEfhFT3YAy95aAgqgngMBxrr+67p5/XC/FptaPJ4sNXRjV
         5DMZ//04Zr66+69FvNR5d5Lna/QDJPWpR4y/VnJDPCgi5mFjXuAUaFvCPrhF/th6f6V/
         QLJA==
X-Forwarded-Encrypted: i=1; AL+hErEuUBxbKfT/7vOcSevK7uLSJ+j0InhQTcUkianB0W744PiBEZr3mSt/VyqJLy/kIPvGLGE5KoVcLA==@kvack.org
X-Gm-Message-State: APuU4Z/aEQElk+Kauo4s+24JDZxoucol5KgnpArKV1JikKi2W1ZanNHY
	1MT3wm6v6znXZZeyhpah4vSVTMqe8S1s6NyuRaT/DOOxFwhtKKssO84zlZQUhq+guPs=
X-Gm-Gg: AYBFou0tccwzdoqxDn4ZFZRTf8GdQWstcSvqhk6woDaE5n75xGGJQm0y/ttuHbmYvCK
	ZPhu/cLX4zDVMYBIMuU7JQYqKyaXn+eig3OaKbhA5dL7+l/EcwjlzM0yNtvoyG8y3ZihgACRzPz
	W65CeAn3nV4tsOiN/Jcf3jB5LhEMLIZ5sxw1vvP7mB4E67PHGl5/wX3Wesl/YwdidjMs/tzcnR2
	iYGMK/jVAQD2NiAPvJy1kpW1cfvaXFSt/XFarB8iHLse2iypWJ7m4mIKPotCelsEoTR8sPoAM2t
	8B985J91mwGXkoF/dR7elb+5N1zL24iDSPhQ9fxwOqS1AXCT7aBmxAbseNpCjI00D2UmzsasGl9
	SG92/BtQjHBEUgAz6yJ+yIuPHLT100AjGhTvI/GZLyCaJk8QIBoJVH6Xj+bl3qc7IOk4YAQhfTB
	surSKt272pJ/ZJHaVdQf3K3mU9zYC1tmGdpUa8ygBFsuYP5XYid7JMvn5ju6WdWS2Xqs69d+K5r
	99ZhxMZFjaaVq1BDsr9UuywIqYvzewTYpCunLSYxu5iTTqJ7NcPdVJvCS5c9iD5a3SqW5gL6HUT
	WK5/6pLraxYUI8003qG6gWiTksSUJRKpRdMoR2F4tRoHX01o+GciFco5JcePCB/bhPbvhk5mkp6
	8miAiauDpNH7xBxEtc4S9nxsyh7fb/xL564Abx/RNQ6S+JMqlenoLmjfZfNsd+1+8PPFf4NpyfY
	xn2OiZpKOEmADtpixZMp/tsOEsHZol5eQZSz0KluLJ2EQEtrlNLUpb
X-Received: by 2002:a05:6a20:431a:b0:3e2:47ab:6a25 with SMTP id adf61e73a8af0-3f2fe3d4734mr1995928637.46.1794383579151;
        Tue, 10 Nov 2026 23:52:59 -0800 (PST)
Received: from localhost ([199.201.64.8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaa86e030sm1861501b3a.27.2026.11.10.23.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 23:52:58 -0800 (PST)
Date: Tue, 10 Nov 2026 23:52:55 -0800
From: Chris Down <chris@chrisdown.name>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Breno Leitao <leitao@debian.org>, Alexander Graf <graf@amazon.com>,
	Baoquan He <baoquan.he@linux.dev>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 1/9] kho: Reclaim the metadata page left reserved after kexec
Message-ID: <63ca64c004b296a998a3e531f8c0c4964916b70c.1794383544.git.chris@chrisdown.name>
References: <cover.1794383544.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1794383544.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5CCDF20007
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: wezz8cu19thnx95n55ms19w3bhd9c7wq
X-Rspam-User: 
X-HE-Tag: 1794383580-565578
X-HE-Meta: U2FsdGVkX18GCXdxQGLHBla9Pj7Z9OIwjWYJhpliI8IoMb+TEEsiBpVPaw7JRE/XFruj3iNyeNkFJm3k4ZKsWbzKYEQnEiCVtChyUQ7pscXtFG2+WblXrN79pLlj7iukFZ8F/pma0COEXGMmqsiGMIaqlbNkhNF+8MrAzhg0eQWlbsU4yh5lvX7HwcEDOHhAPIsKUa9TXn7IcyzAPXmyEG8SDZuAHA4q18WSMNCp6L23Sp1CQgXZqtyWFvitqjrhNwE3D7t/ZgZRID6ugFVyoj3TtjFtu4s6aWh1iEJZTRDd44jbINFmBbRhWoU4a4wpngAMrDpSoN/AO7RtNbueZachsGpIMfSTHcnLs4VyjGAvlbNyqxQ39WYsz8mnDR+Nn5mdUoqKTRZ00411uxMMy3pv35nko1EXamLaXucM+ML0f2AK3CmGe1YPwSgDc/eNMrt6tFIkcHzmty2TswZhofit9rsm1rz0m01UJNczgYwbP1CIPN4QSht71ig4ViO7TFvDSqqdPBOdqExBSj2OIDuTlCuvMcszRswQc+oRInktFG1Ai7sM9s0rt8Kl63d2FZw4mjSSyEU0gw0ZJqTla/RpY4NL8ARvFRbK2vMGxYCvRvOGx8xYH4NnjdFv4jK2vMYaEoOycHdupa7TiXMDtohUPuvNDuM0eVbHoM6711BLVJXZk0JdUclR/90OKTwEBVcDXm0WIcjqUw69TUbLdSpJOeNhwa0WIrQ0124GcNJbtQ5bIyF/LtEg3T3TyC7MLwf/Z0JhRLE0fyGEInN9aSXTeK8Qx0KI4H9+g+ujkZui6aM6kKXls5Qkjr+aA5s8Kk5gCJjG35Su3EhSrXAXYoAemd8A0xcKYuwhloZuj0hR9NEVNSMJPNW0DAJoFNlL/wO1BYUwyJFJX65efpZRE+uPQcW4GX4lyppa6vhUoQVFwmbgYo3qbU4rHBEctNapIbPL85DllM9W5GE3xxC
 9vt3D5Du
 Da3dxz+NZcfHfv5XUi4tN7H4e56p72alkFjhDRort9nDRTAAi4wQXhMdLsYsI/6Ys7HJNC42SCnbUsOes/ITyWtEEgBHxsNHtZEjsLkm5s8I2c4n2Y2dNIOn2C/nbCbAn5o1WYaZIhIoEjXcGekjfhc+fzyCaw1RIz6J5mLcjUOZQ/OZwNbKqxHFZK1H1tDdGGiNX2i94nqeewN+VC6AB2BaOS/Rk0awGdpguUfiDeG5I6fQwi5L+gWsP/dGVIr7EADB075x0bSBPaDE8wE+fV2PTalWmG2UyEATKge5eNcjJjvY945pYJBxo/0VFf7Z4B9/hMqhP6hKpB0rLgqx2CSftsXiNiX/v3Zspzb1jBIYFcz8wtR2G/XC3BJWNP/ai4cEkvDRVG0clU5kDKdW03dCssZBGKKM7R1owq88tvQwvNTvdZKaPZ74Xi3ncgbHr9LDJI/dQUb4VVhKBDGGtCfUjuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

After a KHO kexec, the new kernel keeps the page holding the previous
kernel's kexec metadata reserved for as long as it runs. It only needs
the page once, since kho_in_kexec_metadata() copies the previous release
and the kexec count out of it at boot, and nothing reads it again.

Free it with kho_restore_free() once copying is complete.

Fixes: 76aa46b9e404 ("kho: kexec-metadata: track previous kernel chain")
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 Documentation/admin-guide/mm/kho.rst |  4 +++-
 kernel/liveupdate/kexec_handover.c   | 10 +++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 902d171a780a..f9d2cc5999ee 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -120,4 +120,6 @@ stabilized.
 
 ``/sys/kernel/debug/kho/in/sub_fdts/``
     Similar to ``kho/out/sub_fdts/``, but contains sub blobs
-    of KHO producers passed from the old kernel.
+    of KHO producers passed from the old kernel. A blob disappears
+    once the kernel has read and freed it, as ``kexec-metadata`` does
+    during boot.
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index eeec298aa9d6..3046b89e5db4 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1808,6 +1808,9 @@ static void __init kho_in_kexec_metadata(void)
 
 	pr_info("exec from: %s (count %u)\n",
 		kho_in.previous_release, kho_in.kexec_count);
+
+	kho_debugfs_blob_remove(&kho_in.dbg, metadata);
+	kho_restore_free(metadata);
 }
 
 /*
@@ -1885,14 +1888,15 @@ static __init int kho_init(void)
 	if (err)
 		goto err_free_fdt;
 
+	if (fdt)
+		kho_in_debugfs_init(&kho_in.dbg, fdt);
+
 	err = kho_kexec_metadata_init(fdt);
 	if (err)
 		goto err_free_fdt;
 
-	if (fdt) {
-		kho_in_debugfs_init(&kho_in.dbg, fdt);
+	if (fdt)
 		return 0;
-	}
 
 	for (int i = 0; i < kho_bootmem_cnt; i++) {
 		unsigned long base_pfn = PHYS_PFN(kho_bootmem[i].addr);
-- 
2.54.0


