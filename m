Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F098C606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=VqUAA+zV
Received: by kanga.kvack.org (Postfix)
	id 0E3196B05B6; Wed, 11 Nov 2026 02:53:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094EF6B05B7; Wed, 11 Nov 2026 02:53:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC87A6B05B9; Wed, 11 Nov 2026 02:53:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C42946B05B6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:53:21 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5529940213
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:53:21 +0000 (UTC)
X-FDA: 85422073002.08.66EA1C2
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6DC9240005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:53:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=VqUAA+zV;
	spf=pass (imf11.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.176 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794383599;
	b=V1HwzVQiK/wPocr0mIsHqB2pAmbPm+NwViWKP4LTx3LLghfzGelStPV6a15NsXig7qRavh
	RTM79xY8pMS23pDyXy28Adhy/GRKG/ddbkUvg/41+Is4Yhe25PCBg2/saOz0q+sKvHhB5w
	OFxftwT9SvcPkj8jwJ/t6bRIoWJbzQk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=VqUAA+zV;
	spf=pass (imf11.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.176 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794383599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Kx3wzBfUwksk18ANuXPfQbbKvvrdq3wbuLdN7ATve0=;
	b=cHZ1/LcqP6ZvogzDfPtSSXKhwPqydMOeK82/wEZkkqsa5P9GrLbnbqqwQlj1Te6Mv6AHAe
	L7UwfacP8BHSCoFprfFk9NVLym8gGRQuj62fkqfXI//ZNCM/rlUyzs40DwH1n4H+ljLce2
	6FDFQQpcqQipF28YkpXsvcvGQCX20ow=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cd69954c755so2056934a12.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794383598; x=1794988398; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=2Kx3wzBfUwksk18ANuXPfQbbKvvrdq3wbuLdN7ATve0=;
        b=VqUAA+zVx0e/HDWdnKxPqlUWK8pwj4SXa3EqXuneOJquZNV8nQBNR8mnSzvGzv2gBs
         xCBWel4GSK8gZT3YCRrpApMr95MgyNpruMg+s/gy5WpQcYvAJxrLW41jKuXVKQ8bJvCU
         C6NYzplppHMbNDmV4m6EF0N4n/7vPxuA7E3YM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794383598; x=1794988398;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2Kx3wzBfUwksk18ANuXPfQbbKvvrdq3wbuLdN7ATve0=;
        b=yOY9Nt4yeKfGRxWjLjX2mU1Av15vDCLXJYy5S1iuB9HhgFjLbPJMr1CFd8tPRe0CTk
         hXvh9nNXuKfJo7qkPEEHqbUDJXYTtWJmc1QUtq/R2Ju5tYk+MBsYcoKD7E7nWj9PeIXZ
         CZppS8u37ujr/D5Zhmk2LU8I5no5mXkwrBILjWXCTCHlTUjkM80rDLMwYjVd1HuiWkI3
         in3JTrnl/+UsEo40NfRtYqQgIqrPCSZxBoIikrtS9c0noAhkRX+cbpodbgWmRofR0e1U
         DRm7qRMG2QnyLt2yoqPHqBgApjl0VCwJBXUQH8M+gvnvsf3WJCzW+z2BzXKYS8vcn56w
         xPKg==
X-Forwarded-Encrypted: i=1; AL+hErHXNBR8YxEGAC9Uh+kPHWOvCDBVMskx6+XbaU8r+qji/UeTAaRZaEfD42n+dl5cJ5a7AwEmJPGqSw==@kvack.org
X-Gm-Message-State: APuU4Z9hIR7d3gsNz3QGZEcoM9oLNmaimSm9O1/FXXjr5Hp+vIWnqjRx
	tv5iwHKP8UsPmWkX+NKkdZiu92TBDxYGcx4ZQ3piMbnk+R3Z59YZ8WILndFgQFoGEQ8=
X-Gm-Gg: AYBFou2EsVtLe8WnKbuRTSNErr8pQt4wy8g6g1u1cmPfWvvfVG/VIqVQhTx9mmz06JL
	h8ZgICDPR6R5TfbvFQzv93gXgRTlViwTdq/tHr2CaUWlyi2kPD+4z7L07N9rEZXQCkpLXaG7VzN
	a+K0TtnNUy9/iN/Q47exUxerLPnFoHsbhsD/UQcf4FjVtRY7Dtn6F0RgKtYIpkQxjIH8Mi+1ju4
	+iIgSMTrvbxd/xJLt6+V/dta82J7C9aRQRYSzgOmLjgLj7VzSUhaFRFI1xyK/Uh3r+k3pzi50L4
	IUH6siO3XEGVYOGC+C0JzzbUNzixs/yhm2VSFxfde+VVYHpM9Vc9CDCQ14g1+aXrjHd1qtdS76v
	RSIWKj0q6IzaDkBE7fU8DbY26rEA5B9+b60My83k0lQFBTlEmnhe/CJNcOiLuC5m93QmnBdifiI
	KpJUI09ez/7zj8N8qYSgLC5tfbzal0lCfuSDsznR2QGEvnXD0Uiuctxd14c02aE2q3e6skgRVzQ
	cuRdfbAm213WqLdaTPT5sekjAE5xfaBVNkqbdOkHo4oqochO7ZugmI6qjBYoDasJSqhyFf5Zgdm
	z1z5WyhIvz+TdbqhrDEdEK7Kz22eegYOElMfTxfL6UPCqadENaYXBC4Zi7MReFuUSF8Fd078brK
	iX23fXnNFocYsuxigHUIfa5DzaJWLdp8xC4vN8Z7q8cUj01y+u9pdUxxj9XUFPhoUwvA+n3I5TR
	xXWNQtw7uOl3MIyzar9aZb7smYOsHW3TETOGdU4LZm3iYwh3K+99rQcVqJJ3M6eHibBTla/OnG6
	g==
X-Received: by 2002:a17:90b:4c4d:b0:3b0:9691:a240 with SMTP id 98e67ed59e1d1-3b182ee8638mr1751151a91.47.1794383598151;
        Tue, 10 Nov 2026 23:53:18 -0800 (PST)
Received: from localhost ([199.201.64.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17dbcbaf5sm3506003a91.0.2026.11.10.23.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 23:53:17 -0800 (PST)
Date: Tue, 10 Nov 2026 23:53:14 -0800
From: Chris Down <chris@chrisdown.name>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Baoquan He <baoquan.he@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 3/9] liveupdate: Make failed retrieves distinguishable from
 dropped files
Message-ID: <772c150d0a90139a327803cecf087f6865702753.1794383544.git.chris@chrisdown.name>
References: <cover.1794383544.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1794383544.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6DC9240005
X-Stat-Signature: rtpj6np1o8w3yidcpuqzzdm9ogtw4zpu
X-Rspam-User: 
X-HE-Tag: 1794383599-423675
X-HE-Meta: U2FsdGVkX18OKSVONr/kbRwE0VUYacpscqjDz0nP5w3vpI6HccnnGzYzIFV+DTJsj1laadN8xqpnmD4OmKompjA4Qq6ZGv8F0tH2l7Unf4L0Te8+o1i3pqy1yGhpIzHtv+A53jHQMWYnPIhPBNwm00jt1QEtf4O0aEn3fVPepOCsfoXvTuwWssazwNvo8I7/UfobsQLwZ2cuWYwrgiJmd47hiJ0H9JJfioUeCf/QkctDi0E4yJarg+1dcQjcc7akwwZ8ug3FcXaZIjpu9LRT391iZccCAU4bMqX9QgUv4AnQQHtmk56lrThat/aCZJhHALKtnWMvOxPJVrYBVa3G/h7RE9fu4T4SS83slnGtzOjVYOQ/8tpunAJv3vsV8wsMtxUNecjrpjDOJkkkxq+DYuFb73Hb2WinKzBmyKRPhcuY/JNMRGQiuyFB2VrUKUQw6A5m+mO7iFUPRbj5m1+J2WeSapk+gVp4+jVUw0P6uyyOSgeaRNhXvwyTRi/N1KSYc/ZfUbwDhLBXtR+0k6pZpOSTaj05jZ0jYZTe4VSIhGJwhGsfS1uAl1sm7A+cQFQkDCYX+m0mm/L4tOKhtrpHeBzJSbVH7/+G0PymYHql2hfPj03W01ar3X9dbtfUS2G/ZPW8hvi+zzYhcd1n87lx7O61qF4kTDoP27qKJbC8vqEtB8aXvsu3sskZRyCaBqXMrlPOgtyKrWGHhItHRBTOqBm9HvxgMq/lQbJutsKGzMoWxFc9oLN3eusP6gv0TLVWu8leEHLKEamwwAZe34WBLLEHgf9SigfneDTsNxWFqifGaSIGZflkYVTUY94/sn6QYEeGTs2WlBE+COeZxXGnfODy9bW5XRGLHa2JDAOuNcefzLRsaUMGDJHVypySOChZxYdpuals6zqTTejReCIy8OWqKEizoYILO5IxrzmmDqnIEJgb+gMki6Q8PGl+WTlA/Scacj5JCX4wfQybjqq
 n3gLjvDD
 qmDCdExAZD4d7cCBUYYG9g906E6PyiLmV8Z+py+lZpfH7ghhHqIgF4pi6Xxhs6sbNNhVZXu4SBKnQVVwvE4fX8hmW6GhSaZgmHO2H0PWno0ASw+XIeHWr2OTdlfrK/pElcVT+ZXgZOz3Yb6wLcmxHYlr4eEVN6iFET3tqmD52N/YbVKJd615X3IPGA7uZcMJJPK7J/Zy4wHg3CpO8aKuYsl7CtHQsvzFjvG060VuZwNhcMylOmr5WqEODhyKc+lIAcaX4owuwx8tMYo//gRV89nTnDeX1AE4lfnHTEjOj+oyEhppXJjB2fblx8ylUvSZloSLnxeszX49JxJYB364a0iQZeRd0awWtbxNdfnCf9qRNa52k6Ahs7ETkL4F8Tq22jOp7SDiXyutNfUrKopEhyrGTf2UmfwMNSbXs25xV1/rE/PeSiDOvUu1OWwB+R9hYMo75MfYEtB6aOT31mAnVNx3Agcpf16gs0ILKHZOXp3vCC81ECXk/t3wW7mm7Tsd+aqiVxQK/vBtFqjC4O1ZRHEaIBNNghdymBOOK6kt/Q4jNgtnNp4s8eLGAl+ucHMktyVE2b5LkhldThacXXz5ilJrIRFI3kJWkpUg0i7d7TCMhbWOd5xMDiClL4l3gFSwzspy+gyDiC5eKv1rRSNK+O7ABFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

At Meta, we want to use live update to upgrade hypervisors in place and
preserve service fd stores across systemctl kexec. Our kernel rollout
stops automatically when host health checks fail.

We need it to stop if the new kernel can't give back state that a VMM or
service handed over. We also want to track files that userspace never
asks for.

Today the process that tries a retrieve sees its error, but a fleet
collector can't see that error or tell whether a session went unclaimed.
Opening /dev/liveupdate to check would itself trigger deserialisation on
the first open and can get in the way of the real restorer because the
device is exclusive-open. The collector polls procfs and sysfs, so it
needs a result it can read after the event.

Let's expose the incoming deserialisation state and aggregate session
and file counts under /sys/class/misc/liveupdate/incoming/. A collector
can stop the rollout on state=failed or files_failed > 0, and track
files that were dropped or are still held. The session owner already
knows which VM or service it belongs to, so there is no need to expose
session names.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 .../ABI/testing/sysfs-class-misc-liveupdate   | 44 ++++++++++++++++
 Documentation/userspace-api/liveupdate.rst    |  7 +++
 MAINTAINERS                                   |  1 +
 kernel/liveupdate/luo_core.c                  | 50 +++++++++++++++++++
 kernel/liveupdate/luo_file.c                  | 16 +++++-
 kernel/liveupdate/luo_internal.h              | 34 +++++++++++++
 kernel/liveupdate/luo_session.c               |  6 +++
 7 files changed, 156 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-misc-liveupdate

diff --git a/Documentation/ABI/testing/sysfs-class-misc-liveupdate b/Documentation/ABI/testing/sysfs-class-misc-liveupdate
new file mode 100644
index 000000000000..25e3b49d7aeb
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-misc-liveupdate
@@ -0,0 +1,44 @@
+What:		/sys/class/misc/liveupdate/incoming/
+Date:		Nov 2026
+Contact:	kexec@lists.infradead.org
+Description:
+		Incoming Live Update Orchestrator (LUO) state and counters.
+		Present when live update is enabled. Each attribute is read
+		independently.
+Users:		system monitoring
+
+What:		/sys/class/misc/liveupdate/incoming/state
+Date:		Nov 2026
+Contact:	kexec@lists.infradead.org
+Description:	read only
+		Status of incoming LUO sessions:
+
+		"none"          No sessions were handed over.
+		"pending"       Deserialization has not finished. It
+		                starts on the first open of /dev/liveupdate.
+		"deserialized"  The sessions can be retrieved.
+		"failed"        Deserialization failed. Opening
+		                /dev/liveupdate returns -EIO.
+Users:		system monitoring
+
+What:		/sys/class/misc/liveupdate/incoming/sessions
+What:		/sys/class/misc/liveupdate/incoming/files
+Date:		Nov 2026
+Contact:	kexec@lists.infradead.org
+Description:	read only
+		Number of sessions deserialized and number of files in
+		those sessions, respectively. Counts can be partial while
+		state is "pending" or after it changes to "failed".
+Users:		system monitoring
+
+What:		/sys/class/misc/liveupdate/incoming/files_retrieved
+What:		/sys/class/misc/liveupdate/incoming/files_failed
+What:		/sys/class/misc/liveupdate/incoming/files_dropped
+Date:		Nov 2026
+Contact:	kexec@lists.infradead.org
+Description:	read only
+		Number of successful retrieves, permanent retrieve failures,
+		and files discarded at session finish without a recorded
+		retrieve outcome, respectively. Retrieves and failures are
+		counted when they occur.
+Users:		system monitoring
diff --git a/Documentation/userspace-api/liveupdate.rst b/Documentation/userspace-api/liveupdate.rst
index cdd74627ab75..39bbb91d0dd4 100644
--- a/Documentation/userspace-api/liveupdate.rst
+++ b/Documentation/userspace-api/liveupdate.rst
@@ -45,6 +45,13 @@ For details, see:
 - `sd_pid_notify_with_fds(3)
   <https://www.freedesktop.org/software/systemd/man/latest/sd_pid_notify_with_fds.html>`_
 
+Monitoring
+==========
+
+Read ``/sys/class/misc/liveupdate/incoming/`` to monitor incoming
+sessions and file retrievals without opening ``/dev/liveupdate``.
+See Documentation/ABI/testing/sysfs-class-misc-liveupdate for the sysfs ABI.
+
 See Also
 ========
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 1572f6c905aa..b98b95cd6d12 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15523,6 +15523,7 @@ L:	kexec@lists.infradead.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	Documentation/ABI/testing/sysfs-class-misc-liveupdate
 F:	Documentation/core-api/liveupdate.rst
 F:	Documentation/mm/memfd_preservation.rst
 F:	Documentation/userspace-api/liveupdate.rst
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 1b2bda22902d..ba174e9aae03 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -75,6 +75,8 @@ static struct {
  */
 DECLARE_RWSEM(luo_register_rwlock);
 
+struct luo_incoming_stats luo_incoming_stats;
+
 static int __init early_liveupdate_param(char *buf)
 {
 	return kstrtobool(buf, &luo_global.enabled);
@@ -423,11 +425,59 @@ static const struct file_operations luo_fops = {
 	.unlocked_ioctl	= luo_ioctl,
 };
 
+static const char * const luo_incoming_state_names[] = {
+	[LUO_INCOMING_NONE]		= "none",
+	[LUO_INCOMING_PENDING]		= "pending",
+	[LUO_INCOMING_DESERIALIZED]	= "deserialized",
+	[LUO_INCOMING_FAILED]		= "failed",
+};
+
+static ssize_t state_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	enum luo_incoming_state state = READ_ONCE(luo_incoming_stats.state);
+
+	return sysfs_emit(buf, "%s\n", luo_incoming_state_names[state]);
+}
+static DEVICE_ATTR_RO(state);
+
+#define LUO_INCOMING_ATTR_RO(_name)					\
+static ssize_t _name##_show(struct device *dev,				\
+			    struct device_attribute *attr, char *buf)	\
+{									\
+	return sysfs_emit(buf, "%ld\n",					\
+			  atomic_long_read(&luo_incoming_stats._name));	\
+}									\
+static DEVICE_ATTR_RO(_name)
+
+LUO_INCOMING_ATTR_RO(sessions);
+LUO_INCOMING_ATTR_RO(files);
+LUO_INCOMING_ATTR_RO(files_retrieved);
+LUO_INCOMING_ATTR_RO(files_failed);
+LUO_INCOMING_ATTR_RO(files_dropped);
+
+static struct attribute *luo_incoming_attrs[] = {
+	&dev_attr_state.attr,
+	&dev_attr_sessions.attr,
+	&dev_attr_files.attr,
+	&dev_attr_files_retrieved.attr,
+	&dev_attr_files_failed.attr,
+	&dev_attr_files_dropped.attr,
+	NULL
+};
+
+static const struct attribute_group luo_incoming_group = {
+	.name	= "incoming",
+	.attrs	= luo_incoming_attrs,
+};
+__ATTRIBUTE_GROUPS(luo_incoming);
+
 static struct luo_device_state luo_dev = {
 	.miscdev = {
 		.minor = MISC_DYNAMIC_MINOR,
 		.name  = "liveupdate",
 		.fops  = &luo_fops,
+		.groups = luo_incoming_groups,
 	},
 	.in_use = ATOMIC_INIT(0),
 };
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a39992da504f..3aac1afa05c0 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -543,6 +543,16 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
 	memset(file_set_ser, 0, sizeof(*file_set_ser));
 }
 
+/* Record the first retrieve result. A negative status is permanent. */
+static void luo_file_set_retrieve_status(struct luo_file *luo_file, int status)
+{
+	luo_file->retrieve_status = status;
+	if (status > 0)
+		atomic_long_inc(&luo_incoming_stats.files_retrieved);
+	else
+		atomic_long_inc(&luo_incoming_stats.files_failed);
+}
+
 /**
  * luo_retrieve_file - Restores a preserved file from a file_set by its token.
  * @file_set: The file_set from which to retrieve the file.
@@ -611,7 +621,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	err = luo_file->fh->ops->retrieve(&args);
 	if (err) {
 		/* Keep the error code for later use. */
-		luo_file->retrieve_status = err;
+		luo_file_set_retrieve_status(luo_file, err);
 		return err;
 	}
 
@@ -624,7 +634,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 			  luo_file->file, GFP_KERNEL));
 
 	*filep = luo_file->file;
-	luo_file->retrieve_status = 1;
+	luo_file_set_retrieve_status(luo_file, 1);
 
 	return 0;
 }
@@ -719,6 +729,8 @@ int luo_file_finish(struct luo_file_set *file_set)
 					   struct luo_file, list);
 
 		luo_file_finish_one(file_set, luo_file);
+		if (!luo_file->retrieve_status)
+			atomic_long_inc(&luo_incoming_stats.files_dropped);
 
 		if (luo_file->file) {
 			xa_erase(&luo_preserved_files,
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index dac6644bfb18..504963fc9898 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -77,6 +77,40 @@ struct luo_session {
 
 extern struct rw_semaphore luo_register_rwlock;
 
+/**
+ * enum luo_incoming_state - Deserialization state of incoming sessions
+ * @LUO_INCOMING_NONE: No incoming sessions.
+ * @LUO_INCOMING_PENDING: Deserialization has not finished.
+ * @LUO_INCOMING_DESERIALIZED: Sessions are ready to retrieve.
+ * @LUO_INCOMING_FAILED: Deserialization failed.
+ */
+enum luo_incoming_state {
+	LUO_INCOMING_NONE,
+	LUO_INCOMING_PENDING,
+	LUO_INCOMING_DESERIALIZED,
+	LUO_INCOMING_FAILED,
+};
+
+/**
+ * struct luo_incoming_stats - Incoming session and file counters
+ * @state: Deserialization state.
+ * @sessions: Sessions deserialized.
+ * @files: Files in deserialized sessions.
+ * @files_retrieved: Files retrieved.
+ * @files_failed: Permanent retrieve failures.
+ * @files_dropped: Files discarded without a retrieve outcome.
+ */
+struct luo_incoming_stats {
+	enum luo_incoming_state state;
+	atomic_long_t sessions;
+	atomic_long_t files;
+	atomic_long_t files_retrieved;
+	atomic_long_t files_failed;
+	atomic_long_t files_dropped;
+};
+
+extern struct luo_incoming_stats luo_incoming_stats;
+
 static inline struct liveupdate_session *luo_session_from_file_set(struct luo_file_set *file_set)
 {
 	struct luo_session *session;
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 74bc66929f4b..1a40607bfc45 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -549,6 +549,7 @@ int __init luo_session_setup_incoming(u64 sessions_pa)
 		return err;
 
 	sh->active = true;
+	luo_incoming_stats.state = LUO_INCOMING_PENDING;
 	return 0;
 }
 
@@ -583,6 +584,9 @@ static int luo_session_deserialize_one(struct luo_session_header *sh,
 		return err;
 	}
 
+	atomic_long_inc(&luo_incoming_stats.sessions);
+	atomic_long_add(session->file_set.count, &luo_incoming_stats.files);
+
 	return 0;
 }
 
@@ -626,12 +630,14 @@ int luo_session_deserialize(void)
 	}
 
 	kho_block_set_destroy(&sh->block_set);
+	WRITE_ONCE(luo_incoming_stats.state, LUO_INCOMING_DESERIALIZED);
 
 	return 0;
 
 save_err:
 	kho_block_set_destroy(&sh->block_set);
 	saved_err = err;
+	WRITE_ONCE(luo_incoming_stats.state, LUO_INCOMING_FAILED);
 	return err;
 }
 
-- 
2.54.0


