Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B04BBCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECEB88E001B; Tue,  9 Sep 2025 16:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2AC18E0019; Tue,  9 Sep 2025 16:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF3768E001B; Tue,  9 Sep 2025 16:15:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B35FA8E0019
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:15:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 436EE13B51E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:15:31 +0000 (UTC)
X-FDA: 83870816862.08.53745C8
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	by imf15.hostedemail.com (Postfix) with ESMTP id C91BEA0016
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:15:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=yandex-team.com header.s=default header.b=3cpiG20o;
	spf=pass (imf15.hostedemail.com: domain of arbn@yandex-team.com designates 178.154.239.72 as permitted sender) smtp.mailfrom=arbn@yandex-team.com;
	dmarc=pass (policy=none) header.from=yandex-team.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+17MgeO3e6Rzqq27V24D7dScl7S0GJ/b7/AOl0wS3yU=;
	b=Nf1tRN8kS/B3SZ+KkdriclNc+6fogyCAsLBCg7MVV3zmk9c25bpHgVPdMsdoHs2bqtHIsO
	XOqmlWXSedZNlz/rey2Kw9mxeg2+WwU+wi4M+subyt1AywLqdz3sUhST0s7O4vCIfydsYq
	TVQcLlw4VBRbH6E6AHUrnFkqF0uBRs0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448929; a=rsa-sha256;
	cv=none;
	b=8OyXswavVlSoxWbB68ZJF3UDN2jmsoMyjupTu6jg0AG2mTUoeXMi+w6TA/bD25ySiiJ5+V
	P0wmaeq6ybV0OACLoz7sjc+SIzh02GieiGUNfmFcTaKxqhaYrGJ/H3XqCOZiJ6sZAxPR/N
	AzN6jEmWsCyjI2joyy95xJzQOCqV/84=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=yandex-team.com header.s=default header.b=3cpiG20o;
	spf=pass (imf15.hostedemail.com: domain of arbn@yandex-team.com designates 178.154.239.72 as permitted sender) smtp.mailfrom=arbn@yandex-team.com;
	dmarc=pass (policy=none) header.from=yandex-team.com
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:3a87:0:640:845c:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id C0C87C0164;
	Tue, 09 Sep 2025 23:15:25 +0300 (MSK)
Received: from localhost.localdomain (172.31.115.73-vpn.dhcp.yndx.net [172.31.115.73])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id IFQqlX5GteA0-RyYuLmFh;
	Tue, 09 Sep 2025 23:15:24 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com;
	s=default; t=1757448925;
	bh=+17MgeO3e6Rzqq27V24D7dScl7S0GJ/b7/AOl0wS3yU=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=3cpiG20o3U6FZME2qRzxH9UkGucCIOgj+ws0RguDxOc9OTUVt/lxjv2nuTzgTXiFM
	 AQaUwZhX7nNoclIpVCB/bI8VuSxboIfFeXmYezPfDmSL6tp5eKfPLRCkMafKCWkONx
	 OfH5YiG0hiVGUQ3ZZrJGYTLaRKWGc1QHwLd1VMWY=
From: Andrey Ryabinin <arbn@yandex-team.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	James Gowans <jgowans@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Baoquan He <bhe@redhat.com>,
	kexec@lists.infradead.org,
	Pratyush Yadav <ptyadav@amazon.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	David Rientjes <rientjes@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Chris Li <chrisl@kernel.org>,
	Ashish.Kalra@amd.com,
	William Tu <witu@nvidia.com>,
	David Matlack <dmatlack@google.com>,
	Andrey Ryabinin <arbn@yandex-team.com>
Subject: [PATCH v3 0/7] KSTATE: [de]serialization framework for KHO
Date: Tue,  9 Sep 2025 22:14:35 +0200
Message-ID: <20250909201446.13138-1-arbn@yandex-team.com>
X-Mailer: git-send-email 2.49.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 61ipi1ktnygsbtd88bgysjfykad6m1ga
X-Rspamd-Queue-Id: C91BEA0016
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757448928-514675
X-HE-Meta: U2FsdGVkX1+SxqZO+89cH8LirDuTJv2XV4VP0CP1vpAKK5OKaymb1LuU851nEYjPeEjbcGP8klsRW/5aQ/q5vb3bgzJVeMhu+7sY1CUbtg23jO1tjLfQ0PZlIhZoySByxWsn9TTtS3SQ+byqfvwzKXWNp3jO8/aYh5qYc1nWZOJQ5W7Ffhcowg85exO1wbC0E6r+7WxxTBxljW6Aa/155basTiiw/24ngXGPZTFlpBCVoOgbM86f0vQB4Ra9MN3hV9v+qSsrZTPYsA2WqDdZO/6goD/a6E2b1NnMPQbPiuQa52W00uLcGdslpCsKzEz0t0VMOZsMya0wwktLQ363mXFQqCTDjZ5UwqqL3Psl9lv/0o2TPpBQbDx4WFJHjW3xUPqwbwPK4JgglkjhpjecXnKQ759OU3jAroqe4LrN+Vtnmwp/M+EphmeAkYry96JD3FkG3fHx8jeintvwzv9gFHsPuQ9QjViQPGe+SWMrir6P5YdoDX0HF7Lv5lMqxGD2+DZsKvy4P5A23Ta9giZNcjJ8tEqS8jICIpPbswa7q6DwN58zjeu/FKTgWW6HkcWnNEffFPJG0KOzfvtZenzIhUivg75LsAc2s3VNImAQa0kMu5Jj2uS3MSgoqfJqUgoG+5IrAuF1eJhSr8Wx3IgSs+lvCPYOIIMNbWE6QPR9I1G/+3d5aR6vhvZv3+KCs7t0Nq5rh/kNVyKWrEJ5CxId6pKKdVuG5IXUWpBDkTICEiH5Pm0I6N/rN/DOxZAJ4oW3ykW7qoHgIargNTgyNnoxgvbJQ1qh/FbGkb86fd/FgCpfrUmj79ZUtELm5LZOAvRcFftuGViYGuOzlxMAnt7U2BjNVrCYj12sBKIRMlG8dShQ5m1Z54rfphoxbChMUFEksV6cS9OKYTO/ayWhCbqMdVvwWEn450w1V8yqHwp89ks6i3KKvOkRA4cmRTGPkafE3x7+sVwqRntQsyGmtHA
 uVCe6aKp
 6GVFByrysP7Ati2he0vcpbu+MxFSQ7odzH7W9NW2TtuPgmz3BeBMlKNDhGiadPM/+9QTUcKMr1Mlz4tFGKHBcRlZEhKK7L1sgN9r0jrK1oPCr5YE/krTQwN7t9jZssPyjZsUrBsbSzrlRDrap+0TK5hkt4fATqUThm0JsHgyX0j6Th1UJl/+t0LFVduImKFMHjX/tfufQFZHBdBFFQOBlkHpdcO1CwpEGcujzUVYdCnSo67Unm/0Cx74MY4e/TxIbCkjM1Ny4JmtiYz7SJO0L4Ud3MFEYBmhiosx2mX7lojOtFPdZnfx6ij74x+x9SmoOnUI9x+jTB0lZdXTPREIctW78dgjmh6MpagQpr4uJAmBhOLasME3RVaFKsa9+Vw4A+ENHL2gyW05JoNh1CUGJocrv3EbmkPzcR8j7ymdPwEYmTwD5BNacxiQihmDDOJ7f5eGg1beY2nUjFBw6AiCSQ2zIh/1dxIvC7RWVdZIJYT6MWig9J2MhFB5zEEHGQxasxUZmrcQITo6AFMDXzdM6b2gBXQoIgT7GLhy1gPwuEJRx0I0UYKebHEaRv7KhPyERAXLCtyQ69tdY3iO7GBxDliPWyyLel/sfz2GFiUpCk5q/g2NHDefSxxyS4aDqVDm7+38g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

 Main changes from v2 [1]:
  - Rebase on top of KHO+LUO. Instead of being standalone solution KSTATE now
  relies on KHO for preserving memory.

 Main changes from v1 [2]:
  - Get rid of abusing crashkernel and implent proper way to pass memory to new kernel
  - Lots of misc cleanups/refactoring.

Series depenecies:
 - is_kho_boot() - https://lkml.kernel.org/r/cover.1755721529.git.epetron@amazon.de
 - LUO v3 series - https://lkml.kernel.org/r/20250807014442.3829950-1-pasha.tatashin@soleen.com

GIT:
   git fetch https://github.com/aryabinin/linux.git kstate-v3

TODO:
 - KSTATE currently have only one, global stream of data. We need to add
    substreams (kinda like subtrees in FDT) and integrate them with LUO,
    so we could have per-file streams.
   That is planned to be fixed in v4.

KSTATE (kernel state) is a mechanism to describe some part of the internal
kernel state, save it into the memory preserved by KHO and restore the
state after kexec in the new kernel.

The end goal here is to be able to update host kernel under VMs
with VFIO pass-through devices running on that host. This implies that
we need svae/restore a lot different structs/state across different subsystems.
The purpose of KSTATE is to provide common infrastructure for saving/restoring
complex in-kernel states. Currently KHO uses FDT for that purpose, KSTATE
aims to provide easier for use alternative.

In this series KSTATE provides alternative to FDT usage in KHO, without
replacing it completely. So both can be used and FDT user can be converted
to KSTATE later if needed.

As demonstration memblock's reserved tables converted from FDT to KSTATE,
making the code simpler and smaller:
    include/linux/kstate.h |   1
    mm/memblock.c          | 158
    2 files changed, 49 insertions(+), 110 deletions(-)

The idea behind KSTATE resembles QEMU's migration framework [3], which
solves quite similar problem - migrate state of VM/emulated devices
across different versions of QEMU.

So why not use FDT?

 - The main reason is FDT doesn't provide simple and convenient internal
    API for the drivers/subsystems to preserve internal data.
    E.g. lets consider we have some variable of type 'struct a'
    that needs to be preserved:
	struct a {
	        int i;
        	unsigned long *p_ulong;
	        char s[10];
        	struct folio *folio;
	};

     The FDT-way requires driver/subsystem to have a bunch of code
     dealing with FDT stuff, something like

     a_kho_write()
     {
	     ...
	     fdt_property(fdt, "i", &a.i, sizeof(a.i));
	     fdt_property(fdt, "ulong", a.p_ulong, sizeof(*a.p_ulong));
	     fdt_property(fdt, "s", &a.s, sizeof(a.s));
	     if (err)
	     ...
     }
     a_kho_restore()
     {
             ...
     	     a.i = fdt_getprop(fdt, offset, "i", &len);
	     if (!a.i || len != sizeof(a.i))
	     	goto err
	     *a.p_ulong = fdt_getprop....
     }

    Each driver/subsystem has to solve this problem in their own way.
    Also if we use fdt properties for individual fields, that might be wastefull
    in terms of used memory, as these properties use strings as keys.

   While with KSTATE solves the same problem in more elegant way, with this:
	struct kstate_description a_state = {
        	.name = "a_struct",
	        .version_id = 1,
        	.id = KSTATE_TEST_ID,
	        .state_list = LIST_HEAD_INIT(test_state.state_list),
        	.fields = (const struct kstate_field[]) {
                	KSTATE_BASE_TYPE(i, struct a, int),
	                KSTATE_BASE_TYPE(s, struct a, char [10]),
        	        KSTATE_POINTER(p_ulong, struct a),
                	KSTATE_FOLIO(page, struct a),
	                KSTATE_END_OF_LIST()
        	},
	};

        saving:
	{
		static unsigned long ulong
		static struct a a_data = { .p_ulong = &ulong };
		const int a_data_instance_id = 123;

		kstate_register(&test_state, &a_data, a_data_instance_id);
	}

	restoring:
	{
		static unsigned long ulong
		static struct a a_data = { .p_ulong = &ulong };
		const int a_data_instance_id = 123;

		kstate_restore(&test_state, &a_data, a_data_instance_id);
	}


       The driver needs only to have a proper 'kstate_description' and provide some ID that
       uniquely identifies `a_data` among other instances of 'struct a'. Then call kstate_register()
       which will register a_data to be saved and KHO-finalize stage of kexec reboot.

       After reboot, the kstate_restore() call should restore all parts of a_data, in accordance with
       kstate_description.

       So basically 'struct kstate_description' provides instructions how to save/restore 'struct a'.

So now to the part how this works.

State of kernel data (usually it's some struct) is described by the
'struct kstate_description' containing the array of individual
fields descpriptions - 'struct kstate_field'. Each field
has set of bits in ->flags which instructs how to save/restore
a certain field of the struct. E.g.:
  - KS_BASE_TYPE flag tells that field can be just copied by value,

  - KS_POINTER means that the struct member is a pointer to the actual
     data, so it needs to be dereference before saving/restoring data
     to/from kstate data steam.

  - KS_STRUCT - contains another struct,  field->ksd must point to
      another 'struct kstate_dscription'

  - KS_CUSTOM - Some non-trivial field that requires custom kstate_field->save()
               ->restore() callbacks to save/restore data.

  - KS_ARRAY_OF_POINTER - array of pointers, the size of array determined by the
                         field->count() callback
  - KS_ADDRESS - field is a pointer to either vmemmap area (struct page) or
     linear address. Stored as offset from the base address.

  - KS_END - special flag indicating the end of migration stream data.

kstate_register() call accepts kstate_description along with an instance
of an object and registers it in the global 'states' list.

During 'finalize' phase of KHO we go through the list of 'kstate_description's
and each instance of kstate_description forms the 'struct kstate_entry'
which save into the kstate's data stream.

The 'kstate_entry' contains information like ID of kstate_description, version
of it, size of migration data and the data itself. The ->data is formed in
accordance to the kstate_field's of the corresponding kstate_description.

After the reboot, when the kstate_restore() called it parses KSTATE's data
stream, finds the appropriate 'kstate_entry' and restores the contents of
the object in accordance with kstate_description and ->fields.

 [1] https://lkml.kernel.org/r/20250310120318.2124-1-arbn@yandex-team.com
 [2] https://lkml.kernel.org/r/20241002160722.20025-1-arbn@yandex-team.com
 [3] https://www.qemu.org/docs/master/devel/migration/main.html#vmstate

Andrey Ryabinin (7):
  kho: move fdt setup in separate helper.
  kho: move scratch memory in separate helper.
  kstate: Add KSTATE - [de]serialization framework for KHO
  kho: replace KHO FDT with kstate metadata
  kstate, test: add test module for testing kstate subsystem.
  mm/memblock: Use KSTATE instead of kho to preserve preserved_mem_table
  Documentation, kstate: Add KSTATE documentation

 Documentation/core-api/index.rst       |   1 +
 Documentation/core-api/kstate.rst      | 117 ++++++
 MAINTAINERS                            |   8 +
 arch/x86/include/uapi/asm/setup_data.h |   4 +-
 arch/x86/kernel/kexec-bzimage64.c      |   6 +-
 arch/x86/kernel/setup.c                |   3 +-
 drivers/of/fdt.c                       |   6 +-
 include/linux/kexec.h                  |   2 +-
 include/linux/kstate.h                 | 235 +++++++++++
 kernel/liveupdate/Kconfig              |  16 +
 kernel/liveupdate/Makefile             |   2 +
 kernel/liveupdate/kexec_handover.c     |  95 ++++-
 kernel/liveupdate/kstate.c             | 536 +++++++++++++++++++++++++
 lib/Makefile                           |   2 +
 lib/test_kstate.c                      | 116 ++++++
 mm/memblock.c                          | 158 +++-----
 16 files changed, 1174 insertions(+), 133 deletions(-)
 create mode 100644 Documentation/core-api/kstate.rst
 create mode 100644 include/linux/kstate.h
 create mode 100644 kernel/liveupdate/kstate.c
 create mode 100644 lib/test_kstate.c

-- 
2.49.1


