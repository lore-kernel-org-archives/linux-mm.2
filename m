Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9F2F606A6EE
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 19:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kbHx8ZKV
Received: by kanga.kvack.org (Postfix)
	id 0F81A6B05B1; Fri, 20 Nov 2026 14:29:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9746B05BB; Fri, 20 Nov 2026 14:29:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDAFB6B05BC; Fri, 20 Nov 2026 14:29:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C15E86B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:29:49 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 549641A01A2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:29:49 +0000 (UTC)
X-FDA: 85456487298.07.9A458B0
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id 77FB540004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:29:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kbHx8ZKV;
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795202987;
	b=olzrcjxccR1sG8EA3L8fgoXJp9FrFAXeaEAjfVYfgZxvIL+dFQQjfujXlaZkzTnez2DkYj
	f2fZEXPpI29ae0CVyTD0Mdz0PtISw9lwYZxWClviZUCuiZh5inz3AFHEqzGaJkOheHMhwV
	1hdqZAxCuaAlziid0tYTRiOKky5W8Yg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795202987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ka3sdI51heiAiEj1XMuq2JlrX86IIDTRxLvf6oCKKN8=;
	b=dJnoz4SmwlppuoRIkj6YmLCzSb+Xe0LNJiMhp2WjojrLAxzFDAI1R94fJDTfelQYVFKTkt
	RKEMocKNocv1FWEJi9V+tJDaHt4nGKBYt/Ulj6QWtu+r9Uob76r4BbsJbMfYtsYuQUnX9j
	XvZMYmm2KfpvRAbwvcJXaP3u2YnHJic=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kbHx8ZKV;
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2f037bc348dso11589055ad.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795202986; x=1795807786; darn=kvack.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ka3sdI51heiAiEj1XMuq2JlrX86IIDTRxLvf6oCKKN8=;
        b=kbHx8ZKV/AQIH9m/gVhXg+onh6rJce341VPFUuN5qKv7z2VM9h4WjZYhvy1KhWEk7n
         7Lw8e955ntbwxKKieC57dKExWSUeRidS6RMdrcx2r1r5RaYY7YNLC1R+IfYW8EOt42pz
         B27xRQNaxSEHK7Em5sa8BP0PGd41WB0UMXHuw0jOCo8Jdus8mO59KYxHXH/Vg4TJEXzg
         rGRtKy7SqrpEkUzRYvdlzeuyKVvKFjJQBkM3Q+9sqzKEzfHR8HZ6OngA1TFLjEIiqEjA
         ThBxgUM7BnLKfN8jbyUqSdRSuCwhfvLnFeL5sUPE285KbPqXXIPdNL600v5MzqQsdgx3
         xysw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795202986; x=1795807786;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ka3sdI51heiAiEj1XMuq2JlrX86IIDTRxLvf6oCKKN8=;
        b=gq7kLsXOzDdqesni1IOj/llzpkVKHUN4LFb2KhIvnY/5zQzDAxF4/j5UFD183bEZmA
         j0zyJFrJbFHgQk6Gg1lRvoFHBSPYkA/wyGj6MwTc8UifGwezW40I+Ha7S+qw6AkJRE+L
         GGuFLcOgYnx00j7dFfltrJyIb3SO4yO9MKse8QqxXX33mHMRI8rsLHl8mhX9G9Tw2GpT
         geqcHXuzZNCOdb6XOzHMCaq/LS0SbuaRMnJvvF6vrzijf0+dZCQ8e79X+SLV/SWuICW1
         8moqVnwhUw7JLD8ZPdYf0XLVEHnxlEqFr3myj9HQ5dSxH+zcTrvHtjc0PZLNLzl/Ssv8
         T7QA==
X-Forwarded-Encrypted: i=1; AL+hErHgr08seosTjJeGGhdKALJr3FTN9q8hMRSfwpYXwbVlR0luuo5exDjC6HhR7HbS8r/MlmfwW8RRyg==@kvack.org
X-Gm-Message-State: APuU4Z8RV9MWu2x5UfEh/YhLipK+BLpqmMyiaqMeRFhi9eqlPPG08tVe
	5lfgSPUeYR3SLsFTWWwmGLv9SF8jVVAQlz2CEfWAlQgQWL2+Xj/ZlGzPM4+ZLxCjEA==
X-Gm-Gg: AZFdTZc3wBSw8X0FF/ufLZTXkwmX6VPrF4ZdLvybhBtu8LEHa3uI397qKYY6cjqY0BB
	CToVSsvlmL1zXyqflTeJl7mXr9KILLGPNpziHmcsS5+PFGWgFesfcD3UOGYz78CtvhUgPlEwubX
	oHnbTC3pHpOAs84z3rhmsZJ2/4O9+x6bDL+5lAx1teSEDNbMLIwoxHktqf0zoCIxgwPA79PFOCM
	QG183EtSCMeCzAQyF0I6i2p7eDG1rCL7z9KFcXVqANbf074pe+N1QbYVGRQ0VzoO/0NWwGWKWZv
	JgAtioOjg43hVdUkvU3g3pgNg8V65awW05ecmTU2UE+xCiKXXdaALbqUb4nP6BKIV3gMTVaASCO
	vLFvg9htGQ5NXgJC8QRByMnW5Lmj0MOLY3DXtVtqvEhpUgTFO/amd0KMq9JHKIathukvUAfbi3a
	Y4nlRsUIm6gZ+rlRMRMw6M/dwEwB98WhxdNksUTgC8opjXhdDRkOc8H+nwEH2rZ57sk7AVPNBVT
	0WkGT+iqNAad7yBBVTGgfzXHPJh0vit+OBggLdzoJ9ysjUOBVgNsus2dy6Vu0FrMyvhKTQly5DX
	gWasPERvOXKga/fege/JJ4nXproqd/s1GGAkgz0i0N1SjgCrYY3Nq/f6s/YXgVhM
X-Received: by 2002:a17:902:ef49:b0:2ea:192a:13b8 with SMTP id d9443c01a7336-2f03f1cfb70mr39502795ad.20.1795202985149;
        Fri, 20 Nov 2026 11:29:45 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c2ad2sm18293005ad.16.2026.11.20.11.29.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 11:29:43 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 20 Nov 2026 11:29:42 -0800
Message-Id: <DN0ACH1KR5BS.A33KFC1ZMPTZ@google.com>
To: "Pranjal Shrivastava" <praan@google.com>, "David Matlack"
 <dmatlack@google.com>
Cc: <kexec@lists.infradead.org>, <linux-doc@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-pci@vger.kernel.org>, "Adithya Jayachandran"
 <ajayachandra@nvidia.com>, "Alexander Graf" <graf@amazon.com>, "Alex
 Williamson" <alex@shazbot.org>, "Alex Williamson"
 <alex.williamson@nvidia.com>, "Bjorn Helgaas" <bhelgaas@google.com>, "Chris
 Down" <chris@chrisdown.name>, "Chris Li" <chrisl@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "Jacob Pan"
 <jacob.pan@linux.microsoft.com>, "Jason Gunthorpe" <jgg@nvidia.com>,
 "Jonathan Corbet" <corbet@lwn.net>, "Josh Hilke" <jrhilke@google.com>,
 "Leon Romanovsky" <leonro@nvidia.com>, "Lukas Wunner" <lukas@wunner.de>,
 "Mike Rapoport" <rppt@kernel.org>, "Parav Pandit" <parav@nvidia.com>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Pratyush Yadav"
 <pratyush@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, "Samiullah Khawaja" <skhawaja@google.com>,
 "Shuah Khan" <skhan@linuxfoundation.org>, "Vipin Sharma"
 <vipinsh@google.com>, "William Tu" <witu@nvidia.com>, "Yi Liu"
 <yi.l.liu@intel.com>
Subject: Re: [PATCH v11 09/13] PCI: liveupdate: Adopt ACS controls in
 incoming preserved devices
From: "David Matlack" <dmatlack@google.com>
X-Mailer: aerc 0.21.0
References: <20261118223704.3286085-1-dmatlack@google.com>
 <20261118223704.3286085-10-dmatlack@google.com>
 <awBkg0ODE436CZy0@google.com>
In-Reply-To: <awBkg0ODE436CZy0@google.com>
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 77FB540004
X-Stat-Signature: 8grkbw3xm7z3ose7j4k9y6aer1worx3c
X-Rspam-User:
X-HE-Tag: 1795202987-26276
X-HE-Meta: U2FsdGVkX19o/Gj3V2skMkrmtKHf3RbgSRYEQ/gdNh+y/V6yt7Ok14cK/+0ww+lcS4bgJ80nukrweGHCkgGMyFo0XPG3w24p4OsivhYKeJf8IqCwKedapRozda6d81C/N8vjIEGL6vIeVlmogNxGyeF7LKLMapWgbM5pyBE4sgsOhzNPK0a10VO5sU0Aa8H/R0+fJz1cMSTIGBtlGVpeeTDzq5k/ytjNCn9c+THTTHieiR0QXYs8lfyjxJ9MpZGo6qxutmLurC4S78UiC+AD+ISMPLhy1posjwWV8I50MRg0EZ/yuMEbb/xGXS6I9VJ83A/f7bcEv+21YDbwh9UBPkcNbFGJ/RbagnAJdfbQ5lM/iFfuwKB1yzMcwSPlsC5aLOpHF8GTUbAP0Ob+y9PylYylM2ol8s5BefiOKTYRk/HDbM1gCd6HG936QOuP2fgkYLHreTzfjnhcTCOw7gbELW3hGzsteSjV1/luze73LjGaqr/OW2fF919dn7nAvnUrQl5hYhmsBDnypz4fhkdwxdYcJKAh6OR+uV+ItxDIsms2mQKTSWd1j6+T1O0unej6GLYQZCgYXJeDQDKaw6E/yBdyoOJUdaeE1k4TB7hSX9oMSIpEnjm95MYX87JG06aB8Jmsr/n8JT5nsqX4YZc9xR5mpfkKfM275Pc1wW59VEuNIhWmXA6XOwHUayXVsOuLpXK1O20EKXzmmx0zElTfzaPh1Vg3iB43BcVK+BELxYLycjoOEP/LeXP7BDFbyx2dTC1upX9hiOGTaUrYZbOX2De9xN6uGBfCzSE7nX6QrhMUhJq51A7OfJ5lUNBaKlmPE1WLloq2uTC5Dp57MJxm5dfWJc2b1Kv9ioKuypdg8WCeMFWfRyr3LK7ueEJ3Omn4YAYjKVZNbZ1BRwGCZFPLuGiaQ+gq4q0pZiG2u/Nd1zoTbxJKlsQSHw8cxDpEznVFACcroxjF1NTOKtrb3CK
 72n9BOrW
 YeO08CC9fXaVlEg2b1e1zIDxyXVojg8Hl7Byac2Kl9ibYVPyWUOiZVIznNVeNGeDudrQ1fGsip0tmFzC3M/vWSqd/c/iWrajbWou5e1sw28Dm9WIg9HGTVXinhQKvvzWfpSHcdcRFKAaOqcPFCKMLUCniLHpqxdGU1ZYYN+uomtyeOZh8CceCzT2v3LDjSU0iitKEl6WmAWuLb6BzWlZqtjnSLBcVUMJ9irVIegEpGy2SEAa4EupBSjwN3ayJeyc3H4n6kmz5c0b8zds9/wpZt3uHE5+66zO7sjveBDsi9R4P0wm+5/JQxn55UBI3YL7WkG3Zh0rhO5/CeN/tPvxgRGon2pUupX7coBg4+pLCGSIgAWZ6EGJiDmFBVpBRU5k+2yGbS1728ZadgzIsfnS16gIjzyeKvAmkVBWm0i4qC443IILM87sXzzOBMUUNYhr2akq4TjheWU6Sb1QEW4JEnDQjjW9sZuEHCYX6ipdkthCcBAic7lOcoudWOeNM5y7wbRNsDTPGuqOVcPU0WIz8f65QWXphGTqT91HGlh7gcKxyg0yEpWp74F6oew9hl8Ir+4fBVxF0e7uUa63fQ4pNBbmZG2hdFAVwt001+h2dGV4/okx+JLxUOwMlmwRQ1Uc3cXUPCksTK4ZorII=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri Nov 20, 2026 at 7:17 AM PST, Pranjal Shrivastava wrote:
> On Wed, Nov 18, 2026 at 10:37:00PM +0000, David Matlack wrote:
>> Adopt Access Control Services (ACS) controls on all incoming preserved
>> devices (endpoints and upstream bridges) during a Live Update.
>>=20
>> Adopting ACS controls avoids changing routing rules while memory
>> transactions are in flight from preserved devices. It also keeps IOMMU
>> groups from changing during or after Live Update.
>>=20
>> The adopted controls are recorded by the pci_save_state() call in
>> pci_bus_add_device(), which runs before drivers bind, so they are
>> reapplied by pci_restore_state() if the device is reset. Allocate the
>> ACS save buffer for incoming preserved devices even if they match a
>> device-specific ACS quirk, since their adopted controls live in the ACS
>> capability, and panic if it could not be allocated.
>>=20
>> To simplify ACS adoption, reject preserving any devices that require
>> quirks to enable ACS as those quirks would also have to take Live Update
>> into account. If such a quirk matches an incoming preserved device
>> anyway, e.g. because it was added in the new kernel, log a warning and
>> adopt the device's ACS controls regardless, rather than reprogram a
>> device in the path of a preserved device's memory transactions.
>>=20
>> Signed-off-by: David Matlack <dmatlack@google.com>
>> ---
>>  drivers/pci/liveupdate.c | 75 ++++++++++++++++++++++++++++++++++++++++
>>  drivers/pci/liveupdate.h | 16 +++++++++
>>  drivers/pci/pci.c        | 13 +++++--
>>  3 files changed, 102 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
>> index 00d6fa5236e9..b99a88c2c199 100644
>> --- a/drivers/pci/liveupdate.c
>> +++ b/drivers/pci/liveupdate.c
>> @@ -123,6 +123,9 @@
>>   *
>>   *  * The device cannot be a Virtual Function (VF).
>>   *
>> + *  * The device cannot require device-specific quirks to enable Access
>> + *    Control Services (ACS).
>> + *=20
>
> [...]
>
>> +#include "liveupdate.h"
>>  #include "pci.h"
>> =20
>>  DEFINE_MUTEX(pci_slot_mutex);
>> @@ -1071,9 +1073,13 @@ static void pci_allocate_acs_save_buffer(struct p=
ci_dev *dev)
>>  	/*
>>  	 * Devices that rely on device-specific quirks to enable an ACS
>>  	 * equivalent keep that configuration outside of the ACS Control
>> -	 * register, so they are configured from scratch on restore.
>> +	 * register, so they are configured from scratch on restore. The
>> +	 * exception is devices preserved across a Live Update, which always
>> +	 * adopt the ACS controls established by the previous kernel and need
>> +	 * the buffer to keep them across resets.
>>  	 */
>> -	if (pci_need_dev_specific_enable_acs(dev))
>> +	if (pci_need_dev_specific_enable_acs(dev) &&
>> +	    !pci_liveupdate_was_incoming(dev))
>>  		return;
>> =20
>
> The ACS save buffer is forced for incoming devices that match an
> enable_acs quirk, but neither existing quirk keeps its controls where
> the generic code saves them (Intel PCH Root Ports have no ACS cap,=20
> SPT/UPT has the Control register at +8, not +6). Is the intent that=20
> such devices just lose their adopted controls if they ever lose config
> state later? (e.g. a Root Port D3 cycle after pci_liveupdate_finish())
> If so, maybe worth calling it out in a comment?

The previous kernel refuses to preserve any device that requires a
device-specific quirk to enable ACS, and every kernel that supports
preserving PCI devices already has the PCH and SPT/UPT quirks. So
neither of those quirks can match a device that was preserved by the
previous kernel.

A quirk can only match an incoming preserved device if it is new in the
current kernel (or the previous kernel was built without
CONFIG_PCI_QUIRKS). In that case the previous kernel did not apply the
quirk and programmed the device's standard ACS Control register, which
is what the save buffer captures. So the device just continues with its
non-quirked ACS configuration from the previous kernel.

I will expand the comment and the changelog in v12 to make that clearer:

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b5b578355a1b..f3d58b5e7a5d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1073,10 +1073,14 @@ static void pci_allocate_acs_save_buffer(struct pci=
_dev *dev)
 	/*
 	 * Devices that rely on device-specific quirks to enable an ACS
 	 * equivalent keep that configuration outside of the ACS Control
-	 * register, so they are configured from scratch on restore. The
-	 * exception is devices preserved across a Live Update, which always
-	 * adopt the ACS controls established by the previous kernel and need
-	 * the buffer to keep them across resets.
+	 * register, so they are configured from scratch on restore.
+	 *
+	 * The exception is devices preserved across a Live Update. The
+	 * previous kernel refuses to preserve devices that need such a quirk,
+	 * so a quirk can only match here if the previous kernel did not apply
+	 * it (e.g. the quirk is new in this kernel). The previous kernel then
+	 * programmed the standard ACS Control register, so save it to keep
+	 * the adopted controls across resets.
 	 */
 	if (pci_need_dev_specific_enable_acs(dev) &&
 	    !pci_liveupdate_was_incoming(dev))

>
> Apart from that:
>
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
>
> Thanks,
> Praan

Thanks for the review!

