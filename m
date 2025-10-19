Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FF56CCD1AA
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 06:17:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3B028E0011; Sun, 19 Oct 2025 02:17:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF3648E0002; Sun, 19 Oct 2025 02:17:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8B658E0011; Sun, 19 Oct 2025 02:17:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC9808E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 02:17:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 686FA13B41B
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:17:13 +0000 (UTC)
X-FDA: 84013856346.25.D8B329F
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 868F3160005
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:17:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KIctGdVC;
	spf=pass (imf08.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760854631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+dhzEiy+8NWdg0h4CeSLeODHjNB3Z/i+xinCfvk2bH8=;
	b=63yuUJiu+KWVYgIb5ybppOkpzq0v4EwDYOntfNZKIwvaErvABOzQjCGuAE29gAmTLvIKUv
	V7QeTs9TzYtczH+6TrnZ5ifw6UiILLumPLM3aLNz22uv7u/GWdX5i5J9pmebU/5dLKimrT
	q9TgBGTQZlAzvMjWdV5dCa/wSU8hMj8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KIctGdVC;
	spf=pass (imf08.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760854631; a=rsa-sha256;
	cv=none;
	b=WBrY3Wvl6oo8h618HdYlUMtqDDYezRAgoHrficxWggiAFI/Lh+HtsKUTa4U3HH0JRjzrp2
	OqYjnJtPbomNv487AsEh9FBd30DjsARllRcto9Zu4NRNc7Meh3i5Jcdj92vQcveiurOj8l
	TO/QfYg1cWcnwjwmdhefQGeSBw3mFa0=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3307de086d8so2779230a91.2
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 23:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760854630; x=1761459430; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+dhzEiy+8NWdg0h4CeSLeODHjNB3Z/i+xinCfvk2bH8=;
        b=KIctGdVC1bQeShTAM2zWH8md62l1Alh27dObW0WheqmtLYqrKhDSBmZFUGOTg9hWq4
         4SWSKgiaYNswnhV78sLbU8o1jW9TGmzWJnRUgM+hh9HPGcGEAxdWy11Tw8/H5Ya926Oj
         pDgTNDqoNaAX9I+RlluVVFM/nerISIDZZVF0LlYvhMRKkj8PY+EQ69kR//ijLLtHtAik
         134d1ZseQDBeM6zw4s2CEQyhpF/z9aClpj9bxmyXDVFvGPkEs83Zv3pFtK2+GC0XZnXT
         0x4hpF1KGCWhwwl5Y9D/q2MOmZoIhVrs2f0AapxzyKM/EbJ+gOj8cbB4uqqc9qMafEi3
         wJLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760854630; x=1761459430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+dhzEiy+8NWdg0h4CeSLeODHjNB3Z/i+xinCfvk2bH8=;
        b=i5ciofM/KDEsihJnEGJcBFJ3UB5r0S/VdhoiXyDC3yB1w7gDzoWlAjwFu03/jvIHPq
         xR1ZArbN3fIm3sqbQpyjUL2nukfhnBXhJqyX82gkJwioM89wicr6bQCKOPB0jPfcJwrS
         FJq6xO5P62+LfppnWiOAZ2ISDmYfHRuuz40vInWwxeWN1GoEt2toJgoo/CiYmf6sAe6A
         ogbrzUYcCQW0vsLdzOfQCJagt/Ua9GC1OqAuZ0B/ISKRnD3YFPePMPyYWpbCBFc1NYNl
         yQrtUA8nmcM+aO3eIzenWjxWfbfLrsbWXvNtlkPON8R5jff0cplRscA6c1eVCuHPcOq/
         jVkg==
X-Forwarded-Encrypted: i=1; AJvYcCUCNDXwtDeyCK/lklLMQgPz3R3R534YFeCC573b4VmzvbeSxo1pJtBp4SeqtPO7QAPu3fk70wMR1A==@kvack.org
X-Gm-Message-State: AOJu0Yw1tW73XPWuPidh+EbbWZcx26jKI8jRKoApKHt9zl7mj+xyTPB4
	dSO4CbQCCXDmKTq2JgXsGuXg6n5Zt14W3J4ZMUD6o3+jl4wQ2kQdYSsj5BMqFA==
X-Gm-Gg: ASbGnctxuvypmjrmbmXA6ZhSM47TJvL5BrgmFpDd0GXFeE2Z1cZNuZTjyi0Gs9wG1dP
	Twbdve+L5Ru31ado1deXVmJXcamtq6RwPUT6VX6Y5XuIktIBAxiR7PutyUDp+QE3IgGb378z7s5
	erjkq5bz9EGREL0GDBo3Undlcg8ca+HkVf4vhf9dMYJzs6skqDQUbM9h8i/+ChHIc3T7nqWjMoj
	9nHJOtj9yAQ4nCsdjkU3pkmWDdPrTr69Zqa+umyX+D6jqjvSTb/Du2s1qHCTlt6WVtKWI1DToFZ
	n2XYmwxiFN82X8bJ/f8cWiEEY6yY0ky9SM/ZwZZihVqjJ0sjulJQ6z1/NXgEEglmqtkiXayBfMr
	JDAY0MnrD67iB5mtVirRqvg21H2X05Dc0QwTK2k0HhxapVHcZmDL/Vz/fb/SOkmdqC/Zkh6b54l
	Oxpp/VbXgFvLg/nkk=
X-Google-Smtp-Source: AGHT+IHsfMse1ea3nbYNy4BvjdFagVFMuvl17zEl9LnMyhbIq3nsVQdQyV1KljR01j/1hJqe5RDh3A==
X-Received: by 2002:a17:90b:1e07:b0:32e:7340:a7f7 with SMTP id 98e67ed59e1d1-33bcf85abb4mr10954646a91.2.1760854630353;
        Sat, 18 Oct 2025 23:17:10 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:bc87:d8fe:3e55:7ffb])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b6f302sm4332032a12.38.2025.10.18.23.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 23:17:09 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jiri@resnulli.us,
	stefanha@redhat.com,
	multikernel@lists.linux.dev,
	pasha.tatashin@soleen.com,
	Cong Wang <cwang@multiernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC Patch v2 10/16] Documentation: Add multikernel usage
Date: Sat, 18 Oct 2025 23:16:24 -0700
Message-Id: <20251019061631.2235405-11-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
References: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 868F3160005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: qchk3ptrp41d4i36rm11oc4o5r9gjyfy
X-HE-Tag: 1760854631-285179
X-HE-Meta: U2FsdGVkX1+1S3KsbeY2FdSk+I0eE/+eHcA0EmfOyd/O85lN1TWSlnsM63uBMfOD0n3I7wD32ku9m0e+4SIdvwK/eSG0cL67E9h7gV4ve35h6XJCBIDWKGdcjblhFxANn8K3f30H5qJiN76OE3Y0vdPaGMkT0K1wtUooWt/tVSGPJIo1aSDTDKPEnRRpQMW5unlOI5gnryxmdLnAbg6uIdjL0q84CxuOtNCJXJC3xAxdD0RBF5tbQp0AVW76HKQ/wiDUQeRpVdWcVVQ2dR95gsKeuGCnQbHxZqxAKll7uR/OdgJVKS9sJaALT2iMfDCem9Y0fZCGL23WjeFDpfn9POb5YnhIbdr6P918RcLWjLVCQ8aEDt/wyGl2gBOGqMr0pNcU24UbTwyUDQeKEDVEacQZR4Lif0Dbn3+2It8h25PeXEiu38BFps8PHlgffBGNIBRHXMrQKR1LQkMDPifai6GtYp6dIDk2OeBe56DjHTu7TLETUDV3a3/sFJp+o2/1pzPIFizqWzlC5sauDfqxTpRaEfvnOOAS84113OQ0On4ZBSC/0maNclFPaLO+9gL8AA34ZRHneJ/CcDviokkQs0YeNUwDF9KmpLd/daP+7rqSAGJoS3pRa3Dk8y52dEvhGG1nn5pQ5DXAE6Elp3C3REh5OzUCvunH9/SNqRReyu4NYCol0Si54DrcR7+gsgyrO2I2JYwjNbvPmU4bfZw8YFDJDw2HNHh4rtBvbefwva+oQ4NhVrLkuzqcggpi3XMU5YWqYRV09MtUSk19i//qSpru9x4byL2miAatxcGT3SF28rK8/haU2rprolhkb9dYk8ahMxfQH/YkAEPfDquCuLz3cA/LGk6A4tpqgkROejciFVs10WbUOPJ3tnYTBfkJhK5nRVwycYcbY02j1uqEVwrxh2L4p45yOMkJcwsvN5zLsdYZZj0ks+q58gno7qlIvjhQg627antRiULIbvk
 AW/pPPHz
 qjq35KGv2hZgCIt+04qyPtDrzBtvnO24KTd/as1vdYb4rpiYH5Ka7u6mhxfOVMnD75qjc1VeSDMw9WuWLqgFeWgnrT2UXKJKdcMNWumu1+UouZRZNSa3wVUyPymwsfg4+KNRZbHtzZpTRbFi4uAeiYbKUaNL7xzu6sp/PfeF9vPCG6dQgLTwpqZ3Tjj6O7VA31t5PODV5QYkXUDKBaFUVHdt9aL69vEImsEIenUX3OWlULWVb8/J7yJV/4PTnRVuBT98LTBnPmvKzIE45uCH/NB5yM7QqySaul3AL74nbadl1nonLYjAgMbu7kiHG8GObwVeRzCUU7fXKyzJbG+IRL305MQxQ9dLC0C9iFsaHoRt/IAUKHkanrirU9UU6aMNMPA1oy1Z3yD1vwQCwz6L7lERKMN/UeXqcqG8TBu468xXnrTl/Qlsfl/7kFY2xdkzFQpJ/sfuXM/yJq757GIKlorEebTMoRKWsGCYLgE/sEzLvPhX43Cq2c5HKdw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multiernel.io>

Signed-off-by: Cong Wang <cwang@multiernel.io>
---
 Documentation/multikernel/usage.rst | 215 ++++++++++++++++++++++++++++
 1 file changed, 215 insertions(+)
 create mode 100644 Documentation/multikernel/usage.rst

diff --git a/Documentation/multikernel/usage.rst b/Documentation/multikernel/usage.rst
new file mode 100644
index 000000000000..a2ec8d56ca1d
--- /dev/null
+++ b/Documentation/multikernel/usage.rst
@@ -0,0 +1,215 @@
+===================================
+Multikernel Kernfs Interface Usage
+===================================
+
+Overview
+========
+
+The multikernel kernfs interface provides a clean, user-friendly way to manage multikernel instances through the filesystem. The interface is located at ``/sys/fs/multikernel/`` and supports automatic instance creation from multikernel device trees.
+
+Architecture
+============
+
+::
+
+    /sys/fs/multikernel/
+    ├── device_tree         # Root-level DTB upload (write-only)
+    └── instances/          # Instance directory
+        ├── web-server/     # Instance created from DTB
+        │   ├── id          # Instance ID (read-only)
+        │   ├── status      # Instance status (read-only)
+        │   └── device_tree_source  # Instance DTB in DTS format (read-only)
+        ├── database/       # Another instance
+        │   ├── id
+        │   ├── status
+        │   └── device_tree_source
+        └── ...
+
+Workflow
+========
+
+Phase 1: Instance Creation (Automatic from DTB)
+------------------------------------------------
+
+1. **Create Multikernel Device Tree**
+
+   Create a device tree with multiple instances:
+
+   .. code-block:: dts
+
+      /dts-v1/;
+      / {
+          compatible = "multikernel-v1";
+
+          instances {
+              web-server {
+                  id = <1>;
+                  resources {
+                      cpus = <1>;
+                      memory-bytes = <0x20000000>;   // 512MB
+                  };
+              };
+
+              database {
+                  id = <2>;
+                  resources {
+                      cpus = <2 3>;
+                      memory-bytes = <0x40000000>;   // 1GB
+                  };
+              };
+          };
+      };
+
+2. **Upload Multikernel DTB**
+
+   .. code-block:: bash
+
+      # Compile device tree to binary format
+      dtc -O dtb -o multikernel.dtb multikernel.dts
+
+      # Upload DTB to create instances automatically
+      cat multikernel.dtb > /sys/fs/multikernel/device_tree
+
+   This automatically:
+
+   - Validates DTB format and multikernel-v1 compatibility
+   - Parses each instance in the ``/instances`` node
+   - Creates instance directories under ``instances/``
+   - Reserves memory and CPU resources for each instance
+   - Updates each instance status to "ready"
+
+3. **Check Created Instances**
+
+   .. code-block:: bash
+
+      # List created instances
+      ls /sys/fs/multikernel/instances/
+      # Output: database  web-server
+
+      # Check instance details
+      cat /sys/fs/multikernel/instances/web-server/id
+      # Output: 1
+
+      cat /sys/fs/multikernel/instances/web-server/status
+      # Output: ready
+
+      # View instance device tree
+      cat /sys/fs/multikernel/instances/web-server/device_tree_source
+      # Output: DTS format showing the instance configuration
+
+Phase 2: Kernel Loading (Kexec Integration)
+--------------------------------------------
+
+1. **Load Kernel Image**
+
+   .. code-block:: bash
+
+      # Load kernel for instance ID 1 (web-server)
+      kexec_file_load(..., KEXEC_MULTIKERNEL | KEXEC_MK_ID(1))
+
+   This:
+
+   - Finds pre-reserved resources for instance ID 1
+   - Creates kimage using pre-allocated memory and CPU resources
+   - Updates status to "loading" → "active"
+   - Preserves instance DTB for KHO (Kexec HandOver) restoration
+
+2. **Instance DTB Preservation**
+
+   The multikernel system automatically preserves each instance's device tree during kexec for restoration in the spawn kernel. The spawn kernel will:
+
+   - Detect multikernel KHO data during early boot
+   - Restore the instance's DTB and recreate the instance structure
+   - Re-reserve the same memory and CPU resources
+
+Device Tree Format
+==================
+
+Multikernel DTB Structure
+--------------------------
+
+The multikernel device tree uses the ``/instances`` structure with ``multikernel-v1`` compatibility:
+
+.. code-block:: dts
+
+    /dts-v1/;
+    / {
+        compatible = "multikernel-v1";
+
+        instances {
+            web-server {
+                id = <1>;
+                resources {
+                    cpus = <1>;                      // CPU ID 1
+                    memory-bytes = <0x20000000>;     // 512MB
+                };
+            };
+
+            database {
+                id = <2>;
+                resources {
+                    cpus = <2 3>;                    // CPU IDs 2 and 3
+                    memory-bytes = <0x40000000>;     // 1GB
+                };
+            };
+
+            load-balancer {
+                id = <3>;
+                resources {
+                    cpus = <0>;                      // CPU ID 0
+                    memory-bytes = <0x10000000>;     // 256MB
+                };
+            };
+        };
+    };
+
+Per-Instance DTB Format
+-----------------------
+
+When viewing an instance's ``device_tree_source``, it appears in per-instance format:
+
+.. code-block:: dts
+
+    /dts-v1/;
+
+    /web-server {
+        compatible = "multikernel-v1";
+        id = <1>;
+        resources {
+            cpus = <1>;
+            memory-bytes = <0x20000000>; // 512 MB
+        };
+    };
+
+Resource Properties
+-------------------
+
+- **cpus**: Array of CPU IDs to assign to this instance
+- **memory-bytes**: Memory size in bytes (must be page-aligned)
+- **id**: Unique instance identifier used for kexec operations
+
+The system validates that:
+
+- CPU IDs are valid and available
+- Memory requests don't exceed available multikernel pool
+- Instance IDs are unique
+- All values are properly aligned
+
+Instance States
+===============
+
+- **empty**: Instance created but no resources allocated yet
+- **ready**: DTB processed, resources reserved, ready for kexec
+- **loading**: Kernel being loaded via kexec
+- **active**: Kernel running in this instance
+- **failed**: Error occurred during any phase
+
+Interface Restrictions
+======================
+
+The new kernfs interface has the following restrictions:
+
+- **No manual instance creation**: Use ``mkdir`` under ``instances/`` is disabled
+- **No direct DTB upload to instances**: Instances don't have writable ``device_tree`` files
+- **Centralized DTB management**: All instances must be created via the root ``device_tree`` file
+- **Read-only instance files**: All instance attributes are read-only for consistency
-- 
2.34.1


