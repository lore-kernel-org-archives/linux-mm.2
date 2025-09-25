Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F1BACAC5B1
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 16:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC7D98E000A; Thu, 25 Sep 2025 12:58:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9E688E0001; Thu, 25 Sep 2025 12:58:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB41A8E000A; Thu, 25 Sep 2025 12:58:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5A048E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:58:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 581EF160405
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:58:47 +0000 (UTC)
X-FDA: 83928381894.10.D458655
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 57A244000A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:58:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T+7trI1H;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of chenglongtang@google.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=chenglongtang@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758819525; a=rsa-sha256;
	cv=none;
	b=7j0duUUp03wDh5y+O8S1YjNiRUi9oRrDSjNQnfMuqPMjUKsdXm7biVqty5z9oIFwmVyWKC
	uHnl19/flTNunP/cCbSrhnednN0O0PT6UMjnbJTusmuIu228mBMQ2fn5AERT7v9ptT7mAW
	kQxd2xF74NYTmK2t4yEJNFwfc70VKY8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T+7trI1H;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of chenglongtang@google.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=chenglongtang@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758819525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yq6K8HIdEhD+E9swYwDQPb1XoskrFD+rIaFeN3MEj6U=;
	b=dEjLs+01YN5S2oXaxefpQqNMNbPiNpHQ9cI/lvu3TQNI0vu7uiHpMPlS7i7LL/oKGS7L70
	/vrZ2fSIjK7fT53B3/z4xA/GHpRi4jQuhiT084eromP1Bvi18f1em+yAq75c9VqbKQg9T6
	TSVuTOliTbceyW0xDGJmcvI4ZzR3Pcs=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-57dda094f6cso275e87.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758819523; x=1759424323; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yq6K8HIdEhD+E9swYwDQPb1XoskrFD+rIaFeN3MEj6U=;
        b=T+7trI1HACUPEvVPa60l93Fwvsc5W2hnaSrU2iAjqeQEMSPjtsLi4e229d35oJKj+8
         W3gCFjOTTbKNjOzX+xtBArYbaGGC0InQXE/O0PcpprnEHeTWPse4DjAe9MVFXRCNtoJu
         TEByHVjlu43b7SYa+Lu9Y08dQMjV4vFAQR1Ja/hwbHm34Q6OLz1MU62Wbsrx40MQYZC4
         M1wAdc5oUep9es1KOjqhDYtik9S2Emf9X8qqxfVefhHXD22iBrAEW+LQKFzhdMYJ0Hji
         ifuDhDDm/J2c9gRDqRacA4FbwAUfFnJAXfF7htzl0GtatlD1deaz95deON9BS26Xud13
         JsMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758819523; x=1759424323;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yq6K8HIdEhD+E9swYwDQPb1XoskrFD+rIaFeN3MEj6U=;
        b=nDGTM+mHsdVPEg3MazUgv949z5cMqHjbkPr5QwZHMDKRaaZeSBWQfDq9+yQnZvCfcW
         jaIi6suEe/vDSZ2W/5ZIymubJJSOOWHuQfiLrvEWDl/msYd/MyO/jmLBb5Q/AqCZaZyZ
         XZOsVsAk3pjD5Dwpf19kyc/6ko/lbiolEVMC62FZn4gYRzduL98gtD3GvLDPZhAPunVR
         r3QHrVwLcZSgWA0269rLfXPLAFY/ATCsfCO6hY1LrpwerJ/DHlUJ3heTNAmAT94kugn1
         35QtSoXOwdcRzTQdZU34TQjkA1aljke1N4N5sIAqRt6cP3MiR8LdqbiADugq/lWDa8hr
         fvRw==
X-Forwarded-Encrypted: i=1; AJvYcCUOCFJjhMlhcd697MEb9jIEg92Ptd6xKRbDq+iWcM+xk24mXqdpOy0YkyCMYeLxIiHKDf8JdaExQA==@kvack.org
X-Gm-Message-State: AOJu0YxM7uL0ZQymooK+DlfdKDhz2WjtvVZ8xIHVjlN2ej/RjmQ3NY4u
	tUOy6z+WS9RbUnTm5gSz9OX/fQRgs20SMtUZNmCRmKX0Bl+JBIVpruudf2Wext7XHVxZ4hHCrkF
	bNKsZrWVPDRKfvSjkfqz6fhXW45BHN92PT6mJ6kGI
X-Gm-Gg: ASbGncuk8JptKUDXi6U5YElCAyZCaRS++hCn/mGZ6tPxsJ4SJ7gAwKfj93QnpPwspQR
	Bx1jBU8iZ9AG248HSrjrWN+S+ZqsVo1cm4OV8B2LercHEROyvzatUI1vAeLjuIA4omwedObh6dX
	+TUVXX43w8b+itFipkoXn2b3KggINePdDBgsWps0s5LnsyoqKi8fQTdfrIpgAdiyEjwmsK2ZDmC
	DAi6AuLFvdO2lTedLLaP+XN
X-Google-Smtp-Source: AGHT+IGJxwQPsa1HBrOtLrDgPHg2NyLPfDxj76oZhDbyhTXsObrV+BiQuT52NKznoNST7PhF7zcIbJIyyNp5aMzCq1I=
X-Received: by 2002:ac2:5b81:0:b0:57b:f611:f918 with SMTP id
 2adb3069b0e04-582b2a9560fmr321110e87.3.1758819523044; Thu, 25 Sep 2025
 09:58:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAOdxtTZJqgDNMtqsq51hQ0azanFPLXHMAJ-mRhRS6yjzYhMf_A@mail.gmail.com>
 <aNSSNgUeMSTtlimW@slm.duckdns.org>
In-Reply-To: <aNSSNgUeMSTtlimW@slm.duckdns.org>
From: Chenglong Tang <chenglongtang@google.com>
Date: Thu, 25 Sep 2025 09:58:31 -0700
X-Gm-Features: AS18NWBXIryw_12tNJ7Zcnq0SWl772-SIFkfVkMUoyR0eC464fAlVAG0qvqtTdI
Message-ID: <CAOdxtTan9jvwzbww0Jm6e4nOiCcwH8cvPHHXpNtRU6ZHUBg=4g@mail.gmail.com>
Subject: Re: [REGRESSION] workqueue/writeback: Severe CPU hang due to kworker
 proliferation during I/O flush and cgroup cleanup
To: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, lakitu-dev@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 57A244000A
X-Stat-Signature: pjn4b6dbhr5rt4pao9b8jth3cyziysmb
X-Rspam-User: 
X-HE-Tag: 1758819525-583551
X-HE-Meta: U2FsdGVkX19Gz41XJVhyzcuWqnfCWc8VK6lErh6oKrQEn0h/625e6LstVheVBFacS3EobYmB/HBNOxCbHmHi7Wt7THf0vYNIiezxgHT+YShTVSdsx7lzpLjw061sx4nDJ5kXHbkNBL8ufuEwWkce33vuy/wGFtvgEAmoh+a9zFmn2hxMwU4McxpZwhlbrPwbvehpVj9r2K+uZ5INo1G5XNU/40LEXzlbmBlbaK7l0BSzx33T64kO4X5Jo5xPqqzyuGfIrVy7chYCW8ACFzd5Tt+jzuFs3fYSJHH5upeZeNtV3qF6ee7pDQwwZjn20kkAfBiaB0H2d3gT8P4fm/OOTKiy8bOrMp9D5QGThEN9y4vx+DEGkqHVR3YP/Ylpz5kGkjqvxOMPj0DWMjDVZ5G1ecuxYndz7wmbBXQ9K8Sa2daMGOi8yZBu/d2FoLHTg6FhnFkbevLnfFITQqRsfy+rdJ+egNlwMIGaor0IHEsxJlSnx/wM8Zk1CdP69803YCVZIDj30AqN1QnNpQjltSricRAunvxHluMEFk7XmXt1QntMe0X9kUfke40139OyJh2evWh4qPO3BiUN+xZb8rXFaZUM4LVrIqeGTO54JN3Wc9ZiaiNMD1BGA8w2MRpidbtwleQXeKBTrL2wC3oJgLZnkfXTsweZ9024M14oyaxCH5YzexEqJVdQ4/LVJ7tZg3bNpWeWC1qRXnVQwQyi4HVHDZTCSNLBXbeThk3ArqedSeyRZvH8Q9glqoBkUFMtrVlsdMfr9jHIuaGUjiUk4DXqhsotVJK3HyW8WYWDClhrea9vTj9g7KyGIBcqm510LP7hqXXos58lMUyWAehA8JrnmFF3jDnccTCn9JVo3kb3WChCW9WzS1q1Lf/TK2QLntbDyGHXELorUOPYmCVkLJBzwwZ/1YW3wUYc/QT+Hle6cHnS/Zi7wPYhisERkAY3NHsp9Ryc7W4LpDg00au2oWO
 e6hZbHd2
 man/byLfz+1KwT23VINGRhFB4rQFohIscdrAu+uYBXWq/vzlBsYo5TthqEthSPu+sqiaPH1JsMMheC8Jp0Y3QjqsFPRbrVIGEoBTZ+qn5bJqZWNVHd+a3us78dHto0UaBcXhlQ9NMN3gTVQ8nQx6wCrNAnHGF/uEBkEKRo3H9sJi7rTwVQgmpn5M+5pJd/FOu4lwi2yz6Db8wpBPf8vrfIqexdA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Confirmed the patches worked for the mainline(6.17-rc7). But it's
still flaky(1/13) if I simply apply the patches to v6.12.46.

I think there should be some gap commits that I should apply as well.

Here is the diff between the two kernel versions after patches are applied:

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index fad8ddfa622bb..62d85c5086ba1 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -65,7 +65,7 @@ struct wb_writeback_work {
* timestamps written to disk after 12 hours, but in the worst case a
* few inodes might not their timestamps updated for 24 hours.
*/
-static unsigned int dirtytime_expire_interval =3D 12 * 60 * 60;
+unsigned int dirtytime_expire_interval =3D 12 * 60 * 60;
static inline struct inode *wb_inode(struct list_head *head)
{
@@ -290,6 +290,7 @@ void __inode_attach_wb(struct inode *inode, struct
folio *folio)
if (unlikely(cmpxchg(&inode->i_wb, NULL, wb)))
wb_put(wb);
}
+EXPORT_SYMBOL_GPL(__inode_attach_wb);
/**
* inode_cgwb_move_to_attached - put the inode onto wb->b_attached list
@@ -770,9 +771,8 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
* writeback completion, wbc_detach_inode() should be called. This is used
* to track the cgroup writeback context.
*/
-static void wbc_attach_and_unlock_inode(struct writeback_control *wbc,
- struct inode *inode)
- __releases(&inode->i_lock)
+void wbc_attach_and_unlock_inode(struct writeback_control *wbc,
+ struct inode *inode)
{
if (!inode_cgwb_enabled(inode)) {
spin_unlock(&inode->i_lock);
@@ -802,24 +802,7 @@ static void wbc_attach_and_unlock_inode(struct
writeback_control *wbc,
if (unlikely(wb_dying(wbc->wb) && !css_is_dying(wbc->wb->memcg_css)))
inode_switch_wbs(inode, wbc->wb_id);
}
-
-/**
- * wbc_attach_fdatawrite_inode - associate wbc and inode for fdatawrite
- * @wbc: writeback_control of interest
- * @inode: target inode
- *
- * This function is to be used by __filemap_fdatawrite_range(), which is a=
n
- * alternative entry point into writeback code, and first ensures @inode i=
s
- * associated with a bdi_writeback and attaches it to @wbc.
- */
-void wbc_attach_fdatawrite_inode(struct writeback_control *wbc,
- struct inode *inode)
-{
- spin_lock(&inode->i_lock);
- inode_attach_wb(inode, NULL);
- wbc_attach_and_unlock_inode(wbc, inode);
-}
-EXPORT_SYMBOL_GPL(wbc_attach_fdatawrite_inode);
+EXPORT_SYMBOL_GPL(wbc_attach_and_unlock_inode);
/**
* wbc_detach_inode - disassociate wbc from inode and perform foreign detect=
ion
@@ -1282,13 +1265,6 @@ static void bdi_split_work_to_wbs(struct
backing_dev_info *bdi,
}
}
-static inline void wbc_attach_and_unlock_inode(struct writeback_control *w=
bc,
- struct inode *inode)
- __releases(&inode->i_lock)
-{
- spin_unlock(&inode->i_lock);
-}
-
#endif /* CONFIG_CGROUP_WRITEBACK */
/*
@@ -2475,7 +2451,14 @@ static void wakeup_dirtytime_writeback(struct
work_struct *w)
schedule_delayed_work(&dirtytime_work, dirtytime_expire_interval * HZ);
}
-static int dirtytime_interval_handler(const struct ctl_table *table, int w=
rite,
+static int __init start_dirtytime_writeback(void)
+{
+ schedule_delayed_work(&dirtytime_work, dirtytime_expire_interval * HZ);
+ return 0;
+}
+__initcall(start_dirtytime_writeback);
+
+int dirtytime_interval_handler(const struct ctl_table *table, int write,
void *buffer, size_t *lenp, loff_t *ppos)
{
int ret;
@@ -2486,25 +2469,6 @@ static int dirtytime_interval_handler(const
struct ctl_table *table, int write,
return ret;
}
-static const struct ctl_table vm_fs_writeback_table[] =3D {
- {
- .procname =3D "dirtytime_expire_seconds",
- .data =3D &dirtytime_expire_interval,
- .maxlen =3D sizeof(dirtytime_expire_interval),
- .mode =3D 0644,
- .proc_handler =3D dirtytime_interval_handler,
- .extra1 =3D SYSCTL_ZERO,
- },
-};
-
-static int __init start_dirtytime_writeback(void)
-{
- schedule_delayed_work(&dirtytime_work, dirtytime_expire_interval * HZ);
- register_sysctl_init("vm", vm_fs_writeback_table);
- return 0;
-}
-__initcall(start_dirtytime_writeback);
-
/**
* __mark_inode_dirty - internal function to mark an inode dirty
*

On Wed, Sep 24, 2025 at 5:52=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> On Wed, Sep 24, 2025 at 05:24:15PM -0700, Chenglong Tang wrote:
> > The kernel v6.1 is good. The hang is reliably triggered(over 80% chance=
) on
> > kernels v6.6 and 6.12 and intermittently on mainline(6.17-rc7) with the
> > following steps:
> > -
> >
> > *Environment:* A machine with a fast SSD and a high core count (e.g.,
> > Google Cloud's N2-standard-128).
> > -
> >
> > *Workload:* Concurrently generate a large number of files (e.g., 2 mill=
ion)
> > using multiple services managed by systemd-run. This creates significan=
t
> > I/O and cgroup churn.
> > -
> >
> > *Trigger:* After the file generation completes, terminate the systemd-r=
un
> > services.
> > -
> >
> > *Result:* Shortly after the services are killed, the system's CPU load
> > spikes, leading to a massive number of kworker/+inode_switch_wbs thread=
s
> > and a system-wide hang/livelock where the machine becomes unresponsive =
(20s
> > - 300s).
>
> Sounds like:
>
>  http://lkml.kernel.org/r/20250912103522.2935-1-jack@suse.cz
>
> Can you see whether those patches resolve the problem?
>
> Thanks.
>
> --
> tejun

