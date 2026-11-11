Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 530A460A261D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=rB1N/Jha
Received: by kanga.kvack.org (Postfix)
	id 74CCF6B05C0; Wed, 11 Nov 2026 02:53:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D6D16B05C2; Wed, 11 Nov 2026 02:53:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E2C6B05C3; Wed, 11 Nov 2026 02:53:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 325776B05C0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:53:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B727D16015E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:53:47 +0000 (UTC)
X-FDA: 85422074094.09.5DF31F2
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id DD779100008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:53:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="rB1N/Jha";
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf05.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.42 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794383626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTOr68dqd9pXsH3sDySoD8YNtJ+vod0XkUHzER129hw=;
	b=G7CnsjSzNPPMntmulQY+9DLP/JIl+si7trD3+DBCqSeWFafegKEBfpKfBdidDHgzMfhUjt
	VDY00sQqTOVathnYHtDKdyvisrtXvpDbpcvjJ9H5uXCDSm3eljMPz1X6t1p+OvaZwxdw8+
	4i9yQbrfkDv1LY9SdI9bvM3ORN7kavE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="rB1N/Jha";
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf05.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.42 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794383626;
	b=IJKSgi+OG6P/ZlYmvMYsd0geNraI4fu+YcSfZO5Z7J8XzbJ6r+zM6x1T7gWzaiHBh6mEJF
	e2GI3Ugy5iwBLwuz6U5fwsW3VdCl5NLRHKA9cSdIQyAiE45QkP5lQW20YoOrMdmHWCAP+f
	hCbaeor2fZc4Wpbd4IzPhdaGKjBjuF4=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso19583205e9.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794383624; x=1794988424; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=dTOr68dqd9pXsH3sDySoD8YNtJ+vod0XkUHzER129hw=;
        b=rB1N/JhalleFDLvXZTG4Ut16fmGt58N301IiWlQsH1aoz7cgu6BVDfHUgm3lOPaPpd
         JAHl2EM7XitBWM9ddAX1MnBYEFFqFIXElWJDeILkLp2dL/fqM8o2snjf4cGPZ0t4l/XI
         a28fo7I3PpfGoKcpizqdQ8jcOndech2Hdqykc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794383624; x=1794988424;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dTOr68dqd9pXsH3sDySoD8YNtJ+vod0XkUHzER129hw=;
        b=dyh+c/WOKcfjrNSD+OFZ7uPIW8lNzC2cIFZLeoI9S6eYpFlM0GYCJ+38km/gokUnqb
         QXSOUG9pB/UIFY5DXNjjqhxak6yWnNQBwDWS6nFynBIAOPQjKe7nqakUscLG4c+t7Y3f
         +gmpyH09EVjygf+ZHn5pL2Pw4F8tLKrjPv1OK89yYA/Zq5NxYpRbFWdEAz8xvnhgWNFB
         pI8KH6Bj+llWdDHhquQGSE9Wj+587Yai6QiEFcdg1242lsGrLl6fVhSxeDYG1TyCi3xC
         5XWPs7c114kB9+3YqOSR47T0+QRoJe7IVTpQ2kgSX2+TLWyaWZIykOWJn47qq7Zdd7Ya
         Tg9g==
X-Forwarded-Encrypted: i=1; AL+hErESP2IQ8sE9yN5GjiVBB6zkEgh+3uXcmtJEcuZUN7gbQHmogCza04dzAGQA5J7E5sNlqUo06z8eUQ==@kvack.org
X-Gm-Message-State: APuU4Z93Y+0QEhWpxpm2EfRBXaJHnRqFjB6Z6t643qFRdgS9kRA4zqBU
	1yK92HcjqPGE8XxXlpX6DcAGJjt9av87tC6+HVpsM7yVgGM6kd1nNKwbEA2z+CXa1zk=
X-Gm-Gg: AYBFou3DU7T2G1nboCaO6K4BFOgul3e+fSyJnXOagigPCYuALXJG4XSm9cI36zl5lDI
	EONNbrCJvieR9yZfHb9GkRmYA1tJ1+rkoGn0K0/CkBGzxxYOvFjAzmYh2kb7FNObIG08BUHUh05
	xlAFrB9LvuMRVCWTDtuwwEURG/id+TJJSQ32CJ1oxqYkXQkYJN4zZPEKMZ9iGXcnxlypXBw9LYx
	/FR/idHBHgdW4DN0P8j8HzOU2girEmCVe+pNHopJH9jVREmRXqwVkxL/ZIaRiZCm5suFO5MG5EU
	+d2obWjXEV+v0P1zRD370N0nwCLP7KImOKMtkHz4Xw+mr52KodeOwMjkqKEfolRHWiuwvfe/hCT
	zu/6RHZ4EmKJUu2TOPPImzpLP9TOTl6Abk9jrHDzYbJEWSGD8n2ioKCsePi2KG9JWXRBBFaIRk6
	eg25FHqAlFAgLeBZeOx2Twp3PGwO1gwf+MpeAGaxTlXjftIC6l4ne17xTFvgWV460M1BQRLEMZH
	vAl0Vv1inNbic45uHIXDQurdwux3x9Sw+mr/f86N1/rsjuIeex0KmaV38LT0+hjL8swoWwwyllN
	4YJ8guNZj6pVGMsG5Xo4CmdqCQOIl9f0NjBAm/s1U7ahYfYBhNU49d9BiQlG0BIyYi4DsezUOLw
	eAGA6w+d/7WxqLW1L0QmwrsPzqaooIILz2AtHiz3oiW39TjC1e5lOevTx9q9lvX7O2fidZyqPPk
	w2+bAvuZVkJTlK5T521h6tSxZDG0aHy5zm8mrLisNJEi0+GsW+DN4x
X-Received: by 2002:a05:600c:a00d:b0:4a1:fa27:df7c with SMTP id 5b1f17b1804b1-4ba093acadfmr26469595e9.34.1794383624548;
        Tue, 10 Nov 2026 23:53:44 -0800 (PST)
Received: from localhost ([199.201.64.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba01ff3428sm138135715e9.15.2026.11.10.23.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 23:53:44 -0800 (PST)
Date: Tue, 10 Nov 2026 23:53:41 -0800
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
Subject: [PATCH 8/9] liveupdate: Expose the sequence number for consecutive
 live updates
Message-ID: <6f10302874805eccc3960531194c989cdd1588c4.1794383544.git.chris@chrisdown.name>
References: <cover.1794383544.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1794383544.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DD779100008
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: p974uehyqsztzhronhg5dbuaobmjak3f
X-HE-Tag: 1794383625-554289
X-HE-Meta: U2FsdGVkX1/grMJsJs4AStgGsuXRtzqfhjotWdWBgzbSawVDYfxIufZGzM+UcVtBGnl5n8ZFI4mUr1h8lpeCcEQoDLV8Ty7Cd82jvnaP/bDtxuO4+jCbyaeyfUtSYXaPEnoPSt7OGe0q3qxxh1vkeO78Xik/FllJL0MgRFtWCAjxP5Q/mfvHFIj9yaahMziR72czBA8KoOVXJG6rjwB30xlpu9FwKd4gHZ3g8MfBkWDb/cZjQxG79dp8hl3MKgF8BV6MG1X9siukIHqwl73u1Qfbr+e9p8pBq4jNPKYHqOvD3OAZv+ZuPxSvUssgtlspmqvgex+U1sTMCwFDTUrd5+krbYniBNYoqlfUbOEWfzSA0d4zgCN8KEIOiBdmWdtAMdHq/eZJunuzV/6/qAYCaZP3dI0TO/22rCx19cOhVallEUJRb7fQOCo6LUekJDVmrKMAxydlXwf5ZnxGQPjAjqhWmYDaYPxlup1Sfbr7gCtWs3iZPoi+FIQjorzR+MiRkgXa67MWUXnud7ZeQWyGGYxvOlafv6mRTdiqblz4xSmlve3uKlKFUggcPsnJyGhuX9IspALf5edZ+CvSYy9asfs+ygrHfZF9CLSdh8cwc43DSpx50jRxyTkeaeSTHZMRHq1yAM3Lzs/fASzm/wI8OMU2W5mOGX9biABG5qYlIyYloQtl907fdF4HSj3jgsGUWgH6H9n0/iyWsZNvspAI68I2NDbyPrDrsGozS2I1raGUHaWva781tPEvs2CcuDCAK3wqKiglnrDK/QkRtqhvRT7CgAwh/3t4aY43+V5tSLnWicBVnOTHbGlnIFJga02jAc9uWEktin3nB4FOTAT+PyIgKAD+nprG7unGSuNHsg0wLtns87PDhlUEyHbEahplDnKNfk6+T0VloCxEj3rrj8jPMlWd1dS9e4kZ32yTZM6HCSYjzR6yGKwLAPRjerut0leaw827Hy2ihp3EM/j
 nVKjHWck
 o3ETMCeUnPzg9lyNKnRvH3nilJ+VMotBhA7utYTibWP0YvozgJFLiptY08Q7KZ2nFNthKyAU/Z1zJAKRMmdIstI+/UDVQkwKVDqEhekVKwX4sYGEukVGXDEtS8luUyTaW/XAClBf1V6nCRjVNZkMqMv284/R5A1zgSzL1LAMAA3mUZWqkADNylJ4D/lXNrqXYJipE0r6R3Jr+VYNEMAqBPep/yF1dFKN0NfR0rBgw6aUDEr1yP9GtlFL4/oKECLQFhtG8i7DigqNJ6TS5+yIw7tbpnoAtTLwMlCASYbzNSr9nKjztsNpznSx+fSQOs34s8hPW2jb7FKRdKOzGk2vfYpkAFtddH7riQ2eSVvwDTjPTCcSoISbsUJ73qafhrWD1e+STXM+QQJcMEOaVFVDDIo+XubqjjOGqcN3JfAQQcMKa7T69DaEI6iPM2ljoQ6gddwMAbtp/GJJmBXrFvMZU5z/LxmoeahVRkfnKffvJO4dQRih3MrLji/zId7H9YBrGBY3Z9MqgU1O7yxvelzE8iXM27Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Export LUO's live update sequence number, so that fleet monitoring can
compare hosts on their first live update with hosts that have been
through several.

We want this because some bugs, like memory corruption, may only show up
after several live updates in a row.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 Documentation/ABI/testing/sysfs-class-misc-liveupdate | 9 +++++++++
 Documentation/userspace-api/liveupdate.rst            | 1 +
 kernel/liveupdate/luo_core.c                          | 8 ++++++++
 3 files changed, 18 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-misc-liveupdate b/Documentation/ABI/testing/sysfs-class-misc-liveupdate
index 608f788ef0fa..b0ba0f626793 100644
--- a/Documentation/ABI/testing/sysfs-class-misc-liveupdate
+++ b/Documentation/ABI/testing/sysfs-class-misc-liveupdate
@@ -24,6 +24,15 @@ Description:	read only
 		the underlying KHO handover.
 Users:		system monitoring
 
+What:		/sys/class/misc/liveupdate/incoming/liveupdate_num
+Date:		Nov 2026
+Contact:	kexec@lists.infradead.org
+Description:	read only
+		LUO sequence number passed by the previous kernel. Reads 0
+		if no LUO state was handed over, 1 after the first live
+		update in a sequence, and increments with each update.
+Users:		system monitoring
+
 What:		/sys/class/misc/liveupdate/incoming/sessions
 What:		/sys/class/misc/liveupdate/incoming/files
 Date:		Nov 2026
diff --git a/Documentation/userspace-api/liveupdate.rst b/Documentation/userspace-api/liveupdate.rst
index 39bbb91d0dd4..61c246371200 100644
--- a/Documentation/userspace-api/liveupdate.rst
+++ b/Documentation/userspace-api/liveupdate.rst
@@ -50,6 +50,7 @@ Monitoring
 
 Read ``/sys/class/misc/liveupdate/incoming/`` to monitor incoming
 sessions and file retrievals without opening ``/dev/liveupdate``.
+``liveupdate_num`` gives the LUO sequence number for the current boot.
 See Documentation/ABI/testing/sysfs-class-misc-liveupdate for the sysfs ABI.
 
 See Also
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index ba174e9aae03..3ca7b3875247 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -441,6 +441,13 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(state);
 
+static ssize_t liveupdate_num_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%llu\n", luo_global.liveupdate_num);
+}
+static DEVICE_ATTR_RO(liveupdate_num);
+
 #define LUO_INCOMING_ATTR_RO(_name)					\
 static ssize_t _name##_show(struct device *dev,				\
 			    struct device_attribute *attr, char *buf)	\
@@ -458,6 +465,7 @@ LUO_INCOMING_ATTR_RO(files_dropped);
 
 static struct attribute *luo_incoming_attrs[] = {
 	&dev_attr_state.attr,
+	&dev_attr_liveupdate_num.attr,
 	&dev_attr_sessions.attr,
 	&dev_attr_files.attr,
 	&dev_attr_files_retrieved.attr,
-- 
2.54.0


