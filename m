Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BE08D73E83
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DBDD6B0099; Thu, 29 Jan 2026 16:05:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D626B009B; Thu, 29 Jan 2026 16:05:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 568C16B009D; Thu, 29 Jan 2026 16:05:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 42A4A6B0099
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:05:11 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0D3A71602BF
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:05:11 +0000 (UTC)
X-FDA: 84386231622.08.4BAF175
Received: from mail-qk1-f195.google.com (mail-qk1-f195.google.com [209.85.222.195])
	by imf06.hostedemail.com (Postfix) with ESMTP id 43FE918000B
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:05:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="qREg/PpC";
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.195 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769720709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2izjfMr9wFUktZXLnWxTLQ+Uf13Bf1lvXAJZzNDICcs=;
	b=nFsZW0HjYrhkKAh5UK5a2P7+xmRaSQXtbnO4Oojo9+EWg3j8qR4ARGL42T9hbPbMsuyr5C
	PNkHpLGfHxazp8mE08VR8jwZmxt1mvtbNglfTW5gJG17a7DDQ0dWw35wRL95L+/50yxC+V
	0LVzxv9dm463HADRwaDdupskpsAhesI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769720709; a=rsa-sha256;
	cv=none;
	b=7hPCxBLq87lGp4Zj2jsk1lRtTeznO4Pe/Z368nm8wE3bqEJCQsuNGZJ3LSajJe6hlVVF1N
	Wq0/jHkw9azeRxvcrt0tirhw4A7EeuG+UyHiKwishUCbpsso05jtm/5Fgs732q6ksIXQhq
	K5pnpt/eawGbTD3GNIsHsZ3iyvshDwU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="qREg/PpC";
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.195 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f195.google.com with SMTP id af79cd13be357-8c5389c3cd2so144008485a.0
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769720708; x=1770325508; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2izjfMr9wFUktZXLnWxTLQ+Uf13Bf1lvXAJZzNDICcs=;
        b=qREg/PpCzC9KHwLXyFDd2ZPmCD0edZD/AuRcTv3yd9Wb/yUuBDbalLUNPzapB3HF1L
         1LXm/HMM3TqzWVWbsOqbb8SE/ZUl56YXO3c+lDnQOtk155PpOvCFsbwngcMZr1vaDncR
         LhXg8Hs3vuua6r6z8IsNoXSnyu8IOezRC0v4kraBJU7gR1i3/HpaHNu0t1lalJlgb89m
         Xb0vxKEY9Lzg3rAaXgvxQDodMiXuL0Zxsw3i2lyu40lqnfLUlntlJatf24sjVfWRvJpX
         qZaERW8aRP+st6/aziJZMMTYvaBAiWsgWjz7hX2MFyJ8pibZDcKQrwW04vZ5NSNPqg14
         P/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769720708; x=1770325508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2izjfMr9wFUktZXLnWxTLQ+Uf13Bf1lvXAJZzNDICcs=;
        b=VUNHNMSR3CasG2WnJgANV0eWbavdEQz0ljQM+pJpFhcTKMUlQIoFV4l1DxJES+Px8O
         E2g+WH/OizCDB35iwN3WitvHb+SU+/1Yy3irLf2XchzfaLP63OePObytsvzAM7mcN8lx
         ki7aUt+aRycxNtUKV/ZE2csMKTRDQbtxGPWv6JcP6o2V6yNWD7+j1j4JBBHFFQM0BEyZ
         pGKP8pLOL4FzUDY2fiwA9I3jlIik2k8EcWYgJDJChMWbncLlfeGq5vzsokE3BuvHIwXV
         hKEGO0FUQE2/xLtP7B70ud2dsmkcMa3oqV44zuVlUW4kLdk2TiPtn4XSOH/Rgp19B0+j
         3BHg==
X-Gm-Message-State: AOJu0YwxelT7G6O6Ojx9qCOgU8sPr/feQURasQgcIAr2RPQst60eLkDW
	tiBrkaZYoPQldsH1d9soT4JMG5BMHSLFejAWpWxb5LhA01gO6EjyQ9UF1LMOC6hKoUzOYwVA5Rp
	hvrNN6tR03A==
X-Gm-Gg: AZuq6aLa+4VepToKUCQ4NZ3Xyho8UVhfBbW8GRITpNqmRqKcfmP+WzzS89UejAdUzag
	flDmx7OW2ACQdEHeuzdkfGXg8qVfkw+i6B1A3XT+DBwad+P0f23JF1t1pLohf+GBH97jWMWe9JL
	oe7gr+Is1/OYt9BMu69PLPnWWrf0mKQB+F/S25XnKDkuO8bWa5f6EkJQkU6IgA8/g5cESwAv8WD
	XJgBqkjmVFv7REQ3oqCws2ujJgi3vEZzS8ycdkVec/XhbR0bFHJulG58/0gonpLsxOD/qZrHXvY
	5g19fWafxhzwRjd1NQqX+JQCKRAz5/FUyk1nzLCDBUMSU1w453wV8qi8LIdfOyDS58L1Li3iLOv
	q9Zlj5qkJaomSDQ77pcvQvX3d/PMAsQzWFRBaTJuwDvoR5y5jNV0mvca/UvWfobDNsRxJxF8ndL
	jQy5yRkv0nFIUdN4iBN/J0uJsmhJU3L3fFLoh5+xzLaXIDB33663ibSELYp0NTsP4nEiwIGz+Bg
	Z/NB92ggHVqUA==
X-Received: by 2002:a05:620a:2845:b0:8a4:e7f6:bf57 with SMTP id af79cd13be357-8c9eb258c5dmr134323385a.5.1769720708025;
        Thu, 29 Jan 2026 13:05:08 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c71b859eaesm282041685a.46.2026.01.29.13.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:05:07 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	terry.bowman@amd.com,
	john@jagalactic.com
Subject: [PATCH 9/9] Documentation/driver-api/cxl: add dax and sysram driver documentation
Date: Thu, 29 Jan 2026 16:04:42 -0500
Message-ID: <20260129210442.3951412-10-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129210442.3951412-1-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 43FE918000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: u9azkowsp4erpnez8pyg5megsi5agb14
X-HE-Tag: 1769720709-367419
X-HE-Meta: U2FsdGVkX1/8CW/5mE0HbmserngSXeuxwgMZDx65WVmSjtSafOZRhTfG7XkJLy2cXlmfscu3LTIJWuaLij4lDCVwPjMTnreXyWfEel9xBeAx6UhjUhDIW039jK0ddDhbqmWdbiKfTlLpljHDr9+IGprzmWLUY1JHYnxrpI5eT4x88kARaNvuoAB/dMc5aIbQvjzlCgNrnc6mkCJ6PLujJD9xYrL8roQ3rPLgax3XYLTSrmxhcMBtg0e7g+11/bsBmjBdN6aulUQ7Vj+ez8WwH8BasbWz0d5jvnc8BRIvIRFw8tuifkSgGqQrlTmh8tAPX+WG/nsQOorfFtu6M//mcQK1ak8VGXxLufSLM7LbTu7wxBl0MOcwEEH+fKDlsW1LbHGWdMMP0SXlYn4maPbB46Vb0L5DpfGTAHfo0+rE131XPexdtLtLrtfSQCc0kwfezvzl/AS80QIEN+lZNxjy/1E0CaHXHw4I2LpYaK+nPM1KjLoRk5dY3FqQotBDLjF4u8nuRMnlpgUsXa+n4sX0GsWqS+WnWZ5uUBKb2wF/JWIe+Df1FwDalkc7hxr1kzxrAIecK2zBhj1gwRVK/ssCcPeAJ6FLPsCwYuIS0h1qJgvAi3f1ZA72X9rAOHFag9RUuOxoAb5YHoBIeai87P/NUI7MPGAkpAGARIVSs5hvWoqiGV9UF3+dp3x0WKjFVw9wtd64P/Apqlyk/e/3FT6+ACIKrPKAhIua/+uYWulm2jnN/7V9PT6i+8hTfNiEt3Rzo7O/kwkSujybVbhXDLjKyZwWJj84WXPiZ4Z8jR2p9OSDxUOO+ZJENzJqmB/S6OWeNr8qRLvxyUX++me9yAIWSCQRJaGfsWRscETpdeK7eQwy2E5ZzrxHS4UCa5aKZzXhcp8TPpXAcYlHXbjV6nVhmOIoakbC/7wj2Bt3VmD8HDvVnEHufMKAF4cCmapZbwcb5Igu+1aic8F90wxgAVW
 VAiGQHvy
 jiHyERv7CxygIx+B/gigG3EYJyKisA2k6tzrTfbRg7vD/s+TVIuljzFpehMzjEV7muSHgUWPgdLFc5jpMaDmyfvGiwlhas3tZTYnWC1RRAGWHJX4fN0crcfjO4elVPqx3wYWV15z7/zNu0l4aelxjwHGok5Ptcm87QCRiOHFEDRwXy8ecQUAolasVriLHBu6twCTmfjyUG7Nw4gqMKnYnNAkf1FiwWGCFmkEu4ZuTG6Zn7Q10qI6CiR8if9sJ77+Norvm7v7jp/RjttQNiAHrU+me6/WHzh689UcmVyNShAmFAqGdsXJm2+DNqSmDN1jObNnyAhPeGCiTsRxr62OS9DQCw+qPJ2tcgF/Ym9kIr3S7+QI7nGcbFKOei6Y01ciTngGxgo9ItezZJvMEVqwsUBJGO8Fmq+iqlPRoNvZ4B1qTdUdu7LSbylFAlPRSOSsnoSrGSgWspQ4n/HQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Explain the binding process for sysram and daxdev regions which are
explicit about which dax driver to use during region creation.

Jonathan Corbet <corbet@lwn.net> 
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 .../driver-api/cxl/linux/cxl-driver.rst       | 43 +++++++++++++++++++
 .../driver-api/cxl/linux/dax-driver.rst       | 29 +++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/Documentation/driver-api/cxl/linux/cxl-driver.rst b/Documentation/driver-api/cxl/linux/cxl-driver.rst
index dd6dd17dc536..1f857345e896 100644
--- a/Documentation/driver-api/cxl/linux/cxl-driver.rst
+++ b/Documentation/driver-api/cxl/linux/cxl-driver.rst
@@ -445,6 +445,49 @@ for more details. ::
     dax0.0      devtype  modalias   uevent
     dax_region  driver   subsystem
 
+DAX regions are created when a CXL RAM region is bound to one of the
+following drivers:
+
+* :code:`cxl_devdax_region` - Creates a dax_region for device_dax mode.
+  The resulting DAX device provides direct userspace access via
+  :code:`/dev/daxN.Y`.
+
+* :code:`cxl_dax_kmem_region` - Creates a dax_region for kmem mode via a
+  sysram_region intermediate device.  See `Sysram Region`_ below.
+
+Sysram Region
+~~~~~~~~~~~~~
+A `Sysram Region` is an intermediate device between a CXL `Memory Region`
+and a `DAX Region` for kmem mode.  It is created when a CXL RAM region is
+bound to the :code:`cxl_sysram_region` driver.
+
+The sysram_region device provides an interposition point where users can
+configure memory hotplug policy before the underlying dax_region is created
+and memory is hotplugged to the system.
+
+The device hierarchy for kmem mode is::
+
+  regionX -> sysram_regionX -> dax_regionX -> daxX.Y
+
+The sysram_region exposes an :code:`online_type` attribute that controls
+how memory will be onlined when the dax_kmem driver binds:
+
+* :code:`invalid` - Not configured (default). Blocks driver binding.
+* :code:`offline` - Memory will not be onlined automatically.
+* :code:`online` - Memory will be onlined in ZONE_NORMAL.
+* :code:`online_movable` - Memory will be onlined in ZONE_MOVABLE.
+
+Example two-stage binding process::
+
+  # Bind region to sysram_region driver
+  echo region0 > /sys/bus/cxl/drivers/cxl_sysram_region/bind
+
+  # Configure memory online type
+  echo online_movable > /sys/bus/cxl/devices/sysram_region0/online_type
+
+  # Bind sysram_region to dax_kmem_region driver
+  echo sysram_region0 > /sys/bus/cxl/drivers/cxl_dax_kmem_region/bind
+
 Mailbox Interfaces
 ------------------
 A mailbox command interface for each device is exposed in ::
diff --git a/Documentation/driver-api/cxl/linux/dax-driver.rst b/Documentation/driver-api/cxl/linux/dax-driver.rst
index 10d953a2167b..2b8e21736292 100644
--- a/Documentation/driver-api/cxl/linux/dax-driver.rst
+++ b/Documentation/driver-api/cxl/linux/dax-driver.rst
@@ -17,6 +17,35 @@ The DAX subsystem exposes this ability through the `cxl_dax_region` driver.
 A `dax_region` provides the translation between a CXL `memory_region` and
 a `DAX Device`.
 
+CXL DAX Region Drivers
+======================
+CXL provides multiple drivers for creating DAX regions, each suited for
+different use cases:
+
+cxl_devdax_region
+-----------------
+The :code:`cxl_devdax_region` driver creates a dax_region configured for
+device_dax mode.  When a CXL RAM region is bound to this driver, the
+resulting DAX device provides direct userspace access via :code:`/dev/daxN.Y`.
+
+Device hierarchy::
+
+  regionX -> dax_regionX -> daxX.Y
+
+This is the simplest path for applications that want to manage CXL memory
+directly from userspace.
+
+cxl_dax_kmem_region
+-------------------
+For kmem mode, CXL provides a two-stage binding process that allows users
+to configure memory hotplug policy before memory is added to the system.
+
+The :code:`cxl_dax_kmem_region` driver then binds a sysram_region
+device and creates a dax_region configured for kmem mode.
+
+The :code:`online_type` policy will be passed from sysram_region to
+the dax kmem driver for use when hotplugging the memory.
+
 DAX Device
 ==========
 A `DAX Device` is a file-like interface exposed in :code:`/dev/daxN.Y`. A
-- 
2.52.0


