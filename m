Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 671BB606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=u8WJaF3q
Received: by kanga.kvack.org (Postfix)
	id 2D4CC6B05B3; Tue, 10 Nov 2026 20:54:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 285766B05B4; Tue, 10 Nov 2026 20:54:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19C006B05B5; Tue, 10 Nov 2026 20:54:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E196D6B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:54:10 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 501CD1401CE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:54:10 +0000 (UTC)
X-FDA: 85421167860.10.485F19E
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf05.hostedemail.com (Postfix) with ESMTP id 32B90100003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:54:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=u8WJaF3q;
	spf=pass (imf05.hostedemail.com: domain of chengzhihao1@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=chengzhihao1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794362046;
	b=zIUSSTt7l8gsbzq1j+DRzM3Nk0ydRyQRkpS4/xJ/G8Zah8XPacxJJTuEPNSsmgBz4ET9F0
	gI6q8fwU1QSTsnrcmLS0uAT49puQIj65LrfADKhBb79TdiHKHtCYcbwv8dmF4cxEUQxdER
	eKNfWWyfvZ/1gH5bD5h4JLMXJdqXqR4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=u8WJaF3q;
	spf=pass (imf05.hostedemail.com: domain of chengzhihao1@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=chengzhihao1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794362046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3j8i2RMfXjq7ikEdRoC0M7EhfQxRKXJ1iTD8fT2y+DU=;
	b=thQhUxlqgPEUHMvs5MgLywXiX2JVF206jTvuUFFdWdKW0q0pFwaQqv/5a/oGQPdsAA+/ag
	LzQvjDUFzDDlozQqcR/qqw2s3mg+015igSgAbjW8fxgPX0zm9lixdeBb3buBRm/cvKtCS3
	b1Ur4MyDt+iwzjf+lhPZHpBewQ6EMVo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3j8i2RMfXjq7ikEdRoC0M7EhfQxRKXJ1iTD8fT2y+DU=;
	b=u8WJaF3qwa/K+ecI0wenMsNXgYb0HrhprmHkE4QJODjrBSe4+EjL0OlYwiEG9frJzY+4PPxby
	qRrA9VhuhNZ4ggwJdtZrkD6d3YGfwh7W6Pdcao/OwZASKxUTbOa+r99DHhX+1mx0w7PHC/IOtLO
	utdxMg8JLCv/gqi4hb5i1Kc=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4jPRQ61DyGzKm6m;
	Wed, 11 Nov 2026 09:53:50 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id F100C4055B;
	Wed, 11 Nov 2026 09:53:59 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 whupemo200011.china.huawei.com (7.152.185.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 11 Nov 2026 09:53:57 +0800
Subject: Re: [PATCH v2 28/34] ubifs: don't set SB_RDONLY after errors
To: Christian Brauner <brauner@kernel.org>, <linux-fsdevel@vger.kernel.org>,
	Jan Kara <jack@suse.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, <ecryptfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <jfs-discussion@lists.sourceforge.net>,
	<linux-nilfs@vger.kernel.org>, <exfat@lists.linux.dev>, <linux-mm@kvack.org>,
	<ntfs@lists.linux.dev>, <ocfs2-devel@lists.linux.dev>,
	<linux-btrfs@vger.kernel.org>, <gfs2@lists.linux.dev>,
	<linux-efi@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
	<linux-xfs@vger.kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-28-2f44f64f0b66@kernel.org>
 <0d472865-6cbb-cbb5-b361-1f2bf71dd528@huawei.com>
 <20261110-erfanden-dossier-zahntechnik-efcb7a6439b0@brauner>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <7cc1871c-9209-51ee-9d0e-c46e5adfaf1e@huawei.com>
Date: Wed, 11 Nov 2026 09:53:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261110-erfanden-dossier-zahntechnik-efcb7a6439b0@brauner>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 whupemo200011.china.huawei.com (7.152.185.179)
X-Stat-Signature: fbw6s1tsuqnwk34uop735gubopxn1dyz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 32B90100003
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794362046-778206
X-HE-Meta: U2FsdGVkX1/uXN9xr0EyWCp/59U5q5vTgbZpOoPsqP4X541JStO0+BOL1a3lM8kph2KBzAFhe2e2/2sKTzMmyXzy4jCcLQ7ROfOZOMWPxSMzHHTC2wwiw59Mp+iXnTh5pjPoURR5E4FQdNdrtgvIBLCP8vI6rC5P3lOr2uxDsp9M21QOc9n5av974p6elGqoPvjC9CwKL+OqzSnSwrX82sXR6gEtB31CsNPE8CHt9QDU2DtUGm1TMltBetpIpPaOW/jlHTJDb5l+XjTklvGVYwwLRYPivGEWt0cGLaOxAmMQfS2q68jScHXIxvO3QLbx981127TkqsixbEWF7xcSRNzWAZfWr+6Wjz1dwS0uQZkdBLY3dbPXyAxbj2V45HOx1bVdBhu0y8SUPhp2fjclzTjrcLgKYQZPbbe2JZPdR9rRKuoS7VHiFMXUkFmnQbiEyr+esVDGhOQaZm6sUn1NYi2OWU9t05tW2m/N6yTrtQ3Iv+YkzTt+MqRWzIzkURAX06ejMHU1owVLHev/5BcXZGNjuHoLf56GD9xkzFM3SX04t9QniFrk45UmLsuRkdR0iyBuhUq+E+GCunIFIvLRBbaoENQClWsPX7hKSKrEzZtW0Y2kKoK475Q9BO2yoC1Sz1ruww3lRPat+DQ4WnFIDBBSssXrZDXrQvctK7Y/uZHICH4PnYcD9V2m8OvoGzfFxCPeY85PyGHo9P3767rw6l1IuiN48oKeXvuYHJ0irl67bBtuKnx4lOty5EtTQE1ZRvqaBg0NQwvTfYXwWREvxyrC5DW/BtyhHzVdf3nhZ1YBz+yPAs+AF+m9pgI54l3vdsGlU9CyZlS/y/OwRhRQ0xX8qxhA23iPGx/Rld/YbOUeK3Z3AfdvGmL9U4bSRQbsQo72eI1eJSQzVCr1rtRmLXgO8JubS6OkjmQDHJmcucM2lv48tq7IVJn2Dl/nvR89BZ7e609DUpsYlDm7hKV
 4VbH/4zt
 nRBpWthsCctE41uNxaD9wzS/ilt76vD/nzPmivYm4rUeycVgxosrl5m0VBkzkLaZiYNIsKveZ6QAFfek6J3xiLWtAXA7weqGjfLj2ywyfm8SqGzBzUlyQCEpHVfKdN4KJSjGpc6gg5GUn9wf7nZFWClEVmRqPZq0SLEdyp7DkrcPPWJoHPqX22sl2mfOeaQSDwhr+N/nO9219wZmRyqRqU3Af25a4fD5vGlv18hQRZ8KbPezp1Z146H3aQcL8SSr/N9hmojTUKQJx1hNOKv04DPGSC83jlyt/hyCCRc5lu3ye9Sb8u12c1x3uBXMoveBqITcUvYf7ptVR2huNN8vaEfrbBK9lEH3V0gnBamQkaz0nttSHLGcAzZmuGlXBIRo0ESjIpbww3KxfUds=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

在 2026/11/11 5:54, Christian Brauner 写道:
> On Fri, Oct 30, 2026 at 11:42:15AM +0800, Zhihao Cheng wrote:
>> If we remove the c->ro_error check, ubifs_remount_ro->ubifs_wbuf_sync
>> will return EROFS and trigger ubifs_ro_mode() again, I think we can
>> retain the pre-check placement to trigger more error printing.
> 
> ubifs_ro_mode() doesn't do anything once c->ro_error is set so that
> won't print anything again. But there's no point in syncing the
> write-buffers and writing the master node after an error.
> 
Agreed
> So I'll skip both in ubifs_remount_ro() when c->ro_error is set like
> ubifs_put_super() does and only cancel the write-buffer timers. The
> remount to read-only itself has to keep working because the error
> doesn't set SB_RDONLY anymore.
Agreed.

> 
>> BTW, a remount to read-write after an error is refused too.
> 
> Only if c->ro_mount is set. ubifs_ro_mode() sets SB_RDONLY but never
> c->ro_mount. So after an error on a read-write mount ubifs_reconfigure()
> takes neither branch and reconfigure_super() clears SB_RDONLY again.
Oh, I understand now, you mean the SB_RDONLY flag in vfs layer.
> 
>> The sb_rdonly won't affect the sync_fs_one_sb() after an error, and
>> sb_emergency_ro check in not added into sync_fs_one_sb, should we add
>> the c->ro_error check in ubifs_sync_fs() to prevent the failure
>> ubifs_wbuf_sync executing?
> 
> Yes, I'll return -EROFS from ubifs_sync_fs() when c->ro_error is set.
> After the !wait check so sync_filesystem() still gets to sync_inodes_sb().
Great.
> 
> .
> 


