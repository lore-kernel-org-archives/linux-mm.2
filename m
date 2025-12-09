Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEE8AD1CDC6
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 09:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11AC76B0005; Tue,  9 Dec 2025 04:26:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CBE66B0007; Tue,  9 Dec 2025 04:26:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23DF6B0008; Tue,  9 Dec 2025 04:26:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E27856B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 04:26:36 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49AE5C04F1
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:26:36 +0000 (UTC)
X-FDA: 84199402392.02.AFAC7E2
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id 467D5A0006
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:26:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="O/pi6Hl4";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765272394; a=rsa-sha256;
	cv=none;
	b=IY7/mVoq3ENP/Ybp/tbTlTpNqUUAkj0KMD7d7v9oDz10VgUPR/QxbdJxQMJmCaZT59mZKO
	g+PYYqUynzMU6JzV2wNVCmoO//zkvGIe6hcEtPsY7pW2q1AndAWu7Fju3ynm1wAeob1k7y
	WLPesU5lPnAdMjr1SVU49i3BMgk/oCI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="O/pi6Hl4";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765272394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+KMrNrynUq56JGJGu0f/k+Le4r5p0Oc6JQ1XXsZPhdA=;
	b=j+rHngpl/VUlVCue0ZJ1yneprVwGfJfVWLHkXwb4tuGvinEq94sznX1B9VcyIFZPbAD88d
	ZeZjEwLjjF8LSw8eWngnKyfdk1+HFivKiVMLvjvMTBQ04R/l9/yh7oi714pb+y32dnAGfO
	eEa18xY8Xzg3Zi4EZQEiVInoZ0VblRo=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b77030ffad9so788171866b.0
        for <linux-mm@kvack.org>; Tue, 09 Dec 2025 01:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765272392; x=1765877192; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+KMrNrynUq56JGJGu0f/k+Le4r5p0Oc6JQ1XXsZPhdA=;
        b=O/pi6Hl4zYtRtX2Z/tOsJouExUyMB3mAU0qGinMJsNZfruJO0VRnZd+xZhERIgVhCZ
         /NYvbVr+TWiAp7O3Rbjq0+ZvRj4vWLWshrdDzGDOxuOcieBLdHBvUnOHQk0U1dCfcXYG
         vCKTi9qvUGq36b8dkwoN8oKdxw5NVZoXdd8u9UI0SIELksx/I+Uo5/bVm4vIXntlsLji
         lsHP8h6l5jihPdT7/1ILJ09TP7G+LDyS9Oim0D9ofZMNG6KtkLWHK3HmNtWBYn49BAbO
         tpkkj+faK4hxY0ny6m3njYmC+2A1/dWL06x4BSWHJRly8uuq3z3I3rXfPRWiyLBjpm9b
         6eKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765272392; x=1765877192;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+KMrNrynUq56JGJGu0f/k+Le4r5p0Oc6JQ1XXsZPhdA=;
        b=o0cwkGOdLhUiTCTsc5iY5020KZfocYoC4JvZwrl+/ZqKZzQbGTUpOubSobJafNK9LY
         xPTMh2DErh6JANC1AX6Add+GEfVkkhVCwsglSRZZI2YEdUmU9c9Zl2sq9csmexP/enXl
         34Z9UWT7S3WctbNN0XrozwqWNKPXmQ+p4W/uToIjAeX/8mZDziC6YGchM3vzzXikaA4q
         ACZdjpCc/t68RL+HwtcRakWvyajI1cBpUqc7gkDM0u4BPXPbU2rfZeY8TRM5nBG9oEq9
         K3WFJv25kFeYvFzfLst4j/dYNSBgdDo9ycP0WwvOZF1Bop8dpbnOiKrx1WGhhBbyU6P4
         5jXA==
X-Forwarded-Encrypted: i=1; AJvYcCW8xl+P4rG/LQW302m2RbmBX9j5Z0IFDj01235iqTWHyHIn2kXK5oNZufdtSZ+loVmcQwYOEleCeQ==@kvack.org
X-Gm-Message-State: AOJu0Yz6Tuaui4zYS1OqEvkSyMjUpLK5ivZmCOWnD3+Z3dXrkKBdhud4
	bxShgKdVmcfwrTkWj6hj8QEeyawhxaxPlJajViuGPD3RwDOG3au8v03+
X-Gm-Gg: ASbGnct8NKm3cA3ayQ0jA0fqIQx/RuFV3qHpmqG7Z8xFg48gs2wVeX6yJcyWsR2uHz/
	wzepdwKWIciYvRGOuC1u0jeCkH5ApEDD1D7Y8k+ipQh6MqZzkEQzu9rjHLEcnHGz0MVIOAbHx7G
	qhNdn1Wfr8oIq6dDN3B9dE19bhU2I1RMUoP7AVX4DY8/zmSpLTfogmF+LuAtjEasIbLy2DRRSPk
	t1m2Kni76VRuOMZAdbP1wo+s2fkshwfuRF3/oOUaGFywEQFbAdNt0hfWkWvo6TL86p9UPG4Jv/a
	pRx6jE6Z/CrxuLYh3oZOMwJNRQeX8vvR37VJvDAvhh4KvGVsg8Aae9UqRhwb800rJHkUYye1swQ
	x8g5RraCt8tNvBivZ4OxRQtKniS4i+g2jItNxw0lRetfmqncYw8rIOxYv88Co/bkgOS1m0DJAJa
	ImWTJHH6RO9i7HOOqXCQWRjo694zO8Pa8ZV8oLHevJPAquiVzfFQR/Nws/
X-Google-Smtp-Source: AGHT+IE9FFpdl2rspu/7FzJyV5P74VIeOarY7yREiGOKBVpLl87NcLHGQRQ++Ne5PWDP96mAZawfJg==
X-Received: by 2002:a17:907:3e83:b0:b76:3548:b73b with SMTP id a640c23a62f3a-b7a242bd933mr1294350766b.4.1765272392304;
        Tue, 09 Dec 2025 01:26:32 -0800 (PST)
Received: from f (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f49d24a6sm1307212566b.54.2025.12.09.01.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 01:26:31 -0800 (PST)
Date: Tue, 9 Dec 2025 10:26:22 +0100
From: Mateusz Guzik <mjguzik@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	David Laight <david.laight.linux@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, oliver.sang@intel.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-ID: <ek7v5vxht56g77kbojo35eqdcqdmxjvguf3tp5wnfydopbthb2@xie6b7r53ote>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
 <20251205184342.2cfcc73e@pumpkin>
 <4eea9138-3853-457d-9113-e3caa7f00437@lucifer.local>
 <20251205213449.12bf4819@pumpkin>
 <d8bcc6b5-eb75-4a0f-99a1-295dcb04dfe8@lucifer.local>
 <e7fb4a23-5ece-4a03-8f0d-58517c388eb7@lucifer.local>
 <7006fa60-f4d3-4e7d-8c2b-974e9e4a1224@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7006fa60-f4d3-4e7d-8c2b-974e9e4a1224@suse.cz>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 467D5A0006
X-Stat-Signature: 91w66qq74aw4m6frxzyncd8pwua5ea4f
X-Rspam-User: 
X-HE-Tag: 1765272393-30921
X-HE-Meta: U2FsdGVkX1/DvVVpUNV9phZoh3/TagrJk3/h3gIPYDI/KWCzHTCyBS7Kaeu9HUUBSi2t0KY57ES3+lcu/uM7YqXmvGlRb8R9z0NFBBwHYTNPk54AuhF3eulCqmvf8gDdDpxUhGbF3PjAKRYdUomriD4AJrg+qH8m/8scjBLJFY/9HnhB2/pJqHi60LXr7gyOscYsUlppjWcl2piowLJRtpwEFsJyAg6vBi+m5qa/BTw3Rpty2tQuPSEdjtUD7pck4t+YfPNLNZpwsJ1t3Z1O9W4DH1W2ZTOSNrVEx0AVUJK1yUKDUAPRgjqR6lrCCiWtSnZDhHN2i20IUrjWSYf8B8uufz9xzZO6bRqVXRhavWsSSTGCL7XyvHDevRSUbhzRsp6OG94OlfwUMbIQpnpPb37L+YX5gsTGLNDZW7ZZHuZvETRQ6nM0i1FnfcRdSlKbW1nVX9i2Cuk9oEK88Zb/PW+ueoqX/p23JxDpiEin7KiOHOJ88H21i/827NI6Q+tQ+G5KsqDi8x1rDKtl5r/MSznW5F+swtN7jXxrjpn4M3ZuTVirwFIeCEanIo5wxXJi7otESyuEmjxfdvoPDfzKKa1/P7iEVAeNB++RzTtddlZXHIOADcB4g7+Yl4OQJV62XhbkzcNtsv1p8ukpVs/dx4KfWaxCvGVpXf8Xt3+FlCIKMQayQZ7SGdCbqn4O8VMFEtIMqW8vB+GJ9xfJns7VGQWDNnTF90C21ybxE2nJZiEQIy291YsJg8qJFl7NkBn4kro5Q/nhvpsydow/RllSIp9gVgYrEC4jNMU5LXAYNXMsJ5imo+5ds6/XLKZd5nntkzScgcg1PINELNIaF+4fsTNVtfx5Mszt4q2TirBIb3J5eVDsdGKsV1J7iUWv6SMMN3RC9jHeqHIsXp/9AqqwU3EhlyVHQWlJ1ocJsKSM+gEX1yUgVsdTFgJfvf+ovpMeyyxqJSFU0XFjQI1IsK5
 FBqGMHGW
 wtXNkP1UkiCzp5Z9ZX/d0Ew84SleIwqEMHn2ytIpBtsAYYqm+Ab0lvxgldGKBqRvOzZXWuGx9W9RAI/5JmVEaJevDOM/JHAvJSynDprqtDISRxrkntUlrpdR2Mo9mhvsYriH2Wbil3L4duCjejLmB3LSGqrjbnR/uphsqef6PyMR4FhuaezJS6uoVsLQbfg2vPdlEHEy0nT3LFiCOb11F5+ykwgDhSLukCY90FN2L8uMA4XOIi4x/z7pPbh0nfPKeo8BRaa4al3XK07FN6wZ4e5F38MXHAWRxEKf4UIfQyrxurr6EkzoblO5xt2WpoQIirwxqXEJ6GsUb8WNwGU6Ya/Jst8hoVgrcxj6bEV0fwl1Ccx38Pwn5WST6ALjw1M2gtc1HGYTLiy9sNqcv4UKBEyjUcHs7H2dSqu7IZF3jE+pba2/4/Jei70xF1omej6ptjAriCTpeCMFGrd0LQFKGqDd1bdyHSQHag9WOdh8+G4LqP0jJMcXnr6UQamt4ZlSwdNlQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 09, 2025 at 09:28:10AM +0100, Vlastimil Babka wrote:
> As Mateusz pointed out off-list, the profiles look like mutexes are doing
> less optimistic spinning and more sleeping. Which IMHO isn't something that
> this change can directly affect.
> 

Not mutexes but rwsems.

The bench at hand has some of the code spinlocked, other parts take
rwsems for reading *or* writing.

I had a peek at rwsem implementation and to my understanding it can
degrade to no spinning in a microbenchmark setting like this one,
provided you are unlucky enough.

In particular you can get unlucky if existing timings get perturbed,
which I presume is happening after Lorenzo's patch.

To demonstrate I wrote a toy patch which conditionally converts affected
down_read calls into down_write (inlined at the end).

While the original report is based on a 192-thread box, I was only able
to test with 80 threads. Even so, the crux of the issue was nicely
reproduced.

./stress-ng --timeout 10 --times --verify --metrics --no-rand-seed --msg 80

Top says (times vary, idle is growing over time):
%Cpu(s):  3.3 us, 24.4 sy,  0.0 ni, 72.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st 

... but if I flip the switch to down_write:

%Cpu(s):  6.3 us, 80.9 sy,  0.0 ni, 12.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st

The switch is a sysctl named fs.magic_tunable (0 == down_read; 1 == down_write).

In terms of performance I see the following:

stress-ng: metrc: [2546] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s CPU used per       RSS Max
# sysctl fs.magic_tunable=0 ## down_read
stress-ng: metrc: [2546] msg            63353488     10.01     28.21    213.26   6331298.95      262362.91        30.16          2016
# sysctl fs.magic_tunable=1 ## down_write
stress-ng: metrc: [2036] msg           455014809     10.00     48.79    676.42  45496870.65      627425.68        90.64          2056

That is to say rwsem code is the real culprit and Lorenzo is a random
(albeit deserving) victim.

I see two action items:
- massage the patch back to a state where things compile to the same asm
  as before as it clearly avoidably regressed regardless of the
  aforementioned issue
- figure out what to do with rwsem code for read vs write spinning

I'm not picking this up for the time being, but I might look at this at
some point.

diff --git a/fs/file_table.c b/fs/file_table.c
index cd4a3db4659a..de1ef700d144 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -109,6 +109,8 @@ static int proc_nr_files(const struct ctl_table *table, int write, void *buffer,
 	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
 
+unsigned long magic_tunable;
+
 static const struct ctl_table fs_stat_sysctls[] = {
 	{
 		.procname	= "file-nr",
@@ -126,6 +128,16 @@ static const struct ctl_table fs_stat_sysctls[] = {
 		.extra1		= SYSCTL_LONG_ZERO,
 		.extra2		= SYSCTL_LONG_MAX,
 	},
+	{
+		.procname	= "magic_tunable",
+		.data		= &magic_tunable,
+		.maxlen		= sizeof(magic_tunable),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+		.extra1		= SYSCTL_LONG_ZERO,
+		.extra2		= SYSCTL_LONG_MAX,
+	},
+
 	{
 		.procname	= "nr_open",
 		.data		= &sysctl_nr_open,
diff --git a/ipc/msg.c b/ipc/msg.c
index ee6af4fe52bf..fa835ea53e09 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -474,6 +474,8 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
 	return err;
 }
 
+extern unsigned long magic_tunable;
+
 static int msgctl_info(struct ipc_namespace *ns, int msqid,
 			 int cmd, struct msginfo *msginfo)
 {
@@ -495,11 +497,19 @@ static int msgctl_info(struct ipc_namespace *ns, int msqid,
 	msginfo->msgmnb = ns->msg_ctlmnb;
 	msginfo->msgssz = MSGSSZ;
 	msginfo->msgseg = MSGSEG;
-	down_read(&msg_ids(ns).rwsem);
-	if (cmd == MSG_INFO)
-		msginfo->msgpool = msg_ids(ns).in_use;
-	max_idx = ipc_get_maxidx(&msg_ids(ns));
-	up_read(&msg_ids(ns).rwsem);
+	if (!READ_ONCE(magic_tunable)) {
+		down_read(&msg_ids(ns).rwsem);
+		if (cmd == MSG_INFO)
+			msginfo->msgpool = msg_ids(ns).in_use;
+		max_idx = ipc_get_maxidx(&msg_ids(ns));
+		up_read(&msg_ids(ns).rwsem);
+	} else {
+		down_write(&msg_ids(ns).rwsem);
+		if (cmd == MSG_INFO)
+			msginfo->msgpool = msg_ids(ns).in_use;
+		max_idx = ipc_get_maxidx(&msg_ids(ns));
+		up_write(&msg_ids(ns).rwsem);
+	}
 	if (cmd == MSG_INFO) {
 		msginfo->msgmap = min_t(int,
 				     percpu_counter_sum(&ns->percpu_msg_hdrs),
diff --git a/ipc/util.c b/ipc/util.c
index cae60f11d9c2..c65c8289a54b 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -771,6 +771,7 @@ struct ipc_proc_iter {
 	struct ipc_namespace *ns;
 	struct pid_namespace *pid_ns;
 	struct ipc_proc_iface *iface;
+	bool writelocked;
 };
 
 struct pid_namespace *ipc_seq_pid_ns(struct seq_file *s)
@@ -828,6 +829,8 @@ static void *sysvipc_proc_next(struct seq_file *s, void *it, loff_t *pos)
 	return sysvipc_find_ipc(&iter->ns->ids[iface->ids], pos);
 }
 
+extern unsigned long magic_tunable;
+
 /*
  * File positions: pos 0 -> header, pos n -> ipc idx = n - 1.
  * SeqFile iterator: iterator value locked ipc pointer or SEQ_TOKEN_START.
@@ -844,7 +847,13 @@ static void *sysvipc_proc_start(struct seq_file *s, loff_t *pos)
 	 * Take the lock - this will be released by the corresponding
 	 * call to stop().
 	 */
-	down_read(&ids->rwsem);
+	if (!READ_ONCE(magic_tunable)) {
+		down_read(&ids->rwsem);
+		iter->writelocked = false;
+	} else {
+		down_write(&ids->rwsem);
+		iter->writelocked = true;
+	}
 
 	/* pos < 0 is invalid */
 	if (*pos < 0)
@@ -871,7 +880,10 @@ static void sysvipc_proc_stop(struct seq_file *s, void *it)
 
 	ids = &iter->ns->ids[iface->ids];
 	/* Release the lock we took in start() */
-	up_read(&ids->rwsem);
+	if (!iter->writelocked)
+		up_read(&ids->rwsem);
+	else
+		up_write(&ids->rwsem);
 }
 
 static int sysvipc_proc_show(struct seq_file *s, void *it)

