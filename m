Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6733606FCF9
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iPOrW1sZ
Received: by kanga.kvack.org (Postfix)
	id 02FAE6B05C7; Tue,  3 Nov 2026 10:01:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007EF6B05D4; Tue,  3 Nov 2026 10:01:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87196B05D5; Tue,  3 Nov 2026 10:01:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C33426B05C7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:01:45 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2EF63160496
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:01:44 +0000 (UTC)
X-FDA: 85394122128.15.694C078
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8D136140038
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:01:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iPOrW1sZ;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793718099;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H4Y/D8MHsuJxIcgQs16JMa9LVQhoWAXgdYCn9GW8dZE=;
	b=m7MpW0aXKLn/EmBfN2FyStstPCNHi8YVLYNWkwAPqRQXsZoI9DPAaA2UCha6EVulh5+rTX
	hAKAUnlwEm7RRrA9BKbGPvClLzj+gJAL8TLE2O6wOQTC7fg5IgkjOYYCQIZVm60NbfVFyg
	JqZAUEcaI0Y5dgFQQOO3DbOC3N6x2MY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iPOrW1sZ;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793718099;
	b=Ex/6IJG0SBGEYdf52BIH5VWooqJ6FdmpXZ2ZiKk99U0FcYTfQhqx2RwpBVKGrpXWCnE56R
	QCeFA05RTV6Jh0yS3hjL9ZWkRoQRdiEQnY5JmIsttE9D3pPLBwWz/n/4NbF0AFBmJJJXca
	A0xyg3eJer7vfsdhbk+MaoeRkq83V7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDF8460A01;
	Tue,  3 Nov 2026 15:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664741F0093A;
	Tue,  3 Nov 2026 15:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718098;
	bh=H4Y/D8MHsuJxIcgQs16JMa9LVQhoWAXgdYCn9GW8dZE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iPOrW1sZYpx/JoZZqS9qV1GcjvdBuAyBkHMbgeIvuF9N8xnYtd/uAH/lu/jAlLzKf
	 Nq5vM4zhxl93ARwt5IDAUvoCbIWrHeNs/6trXeNMyLqwoaSZliHN1Lmdtd6F1TrRM+
	 E8t3nn11OR2O0yTsAAjfZ0JhJXAcI/KIsNGJZleh6tn4/huZCrKzH0zz2IUXdKnzkK
	 6W9TGbxhz+i9CE9TQ8pBES4DkH/dBUxXGqSsH1jdznxKqWRCNHZxYwypnamo4/Cqy5
	 fIsF/ocsyOzXijxNmThFmUaDNsK0S2Y+yjWibAtCyfn78+Zol7hiv1kIJFamvcET5T
	 yE9Ruio9sbg7Q==
Message-ID: <sashiko-outbox-195542@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 15/16] proc: let procfs copy ioctl arguments in and
 out
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Josef
 Bacik" <josef@toxicpanda.com>, "Chris Mason" <mason@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>, "Greg
 Kroah-Hartman" <gregkh@suse.de>, "Joel Granados" <joel.granados@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, "Takashi
 Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, tytso@mit.edu, dmitry.torokhov@gmail.com, "Petr
 Pavlu" <petr.pavlu@suse.com>, "Anna Schumaker" <anna@kernel.org>, yukuai@fygo.io, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261102-work-procfs-core-v1-15-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-15-75df35e4f8b8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:01:36 +0000
X-Stat-Signature: 6ont7qzqdc7z9r4kdgnj1tzc5mptexfb
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8D136140038
X-HE-Tag: 1793718099-586636
X-HE-Meta: U2FsdGVkX1+7Bbk50O3J2a5Z2sloa9wewx0BAGoWo38mYDFh1cQpBbVoG4BPJ5EfSe6wNHRwgybaeNJF1JfNM/pLNYj58iZSmifOnvBmbfBgZY1yVB7VAb/OztiAq+MAtBQfYbwlIgbpVe3K/is/wJaI8sJazgzdrWJHDUgpJk+HKhjbMHRLzs27hEjoDEHelCeNUm+WfCALgwjvI4wSn8DVWL4Ze4larkVMPCJybynkWRLrNXL8XG1Vfg+ybdDzD62vxyM5n48O2Zum6/S8pfKAfD5J8B1Swt+QvDnSJa0DMdo275bjc8g1TKUgnan+Dl4cZsgs7XawT7bCoSbRgXcpI189WWYySLUG8RhPcqJMUguG5bivH0INrZrSC3PIlB9zwoZgY4cTbGl3xFHJ2UWVVXvnQOuBw5GdRWF/A4/LIXN2uhVC4XkKQeEwmgxrL4KCyNwWInnxpFrcroMll6AckYC60OCFbT8zVC3JMYl4cIXPgbXKi8niNJoY7zeejuevRBDXfqsyDkSt2zOFATyvqC11Pi1KQjQrk0OOpAyCv2gliwKCySj+Izgcw5GWZ2HgVGtk9OlEr9OyyLVbIf536c4EhXjaE8Yxy9HJud9n9pIryZYwAmIibTK5ilGC3e8e9fn9pgAPvgtJxv/cSROH87CZmaxGTT2oaGPastg2G3EmIpbADsA0ELbJRXxgzIlIgC60DXA2QBqRhBQ5Iou3FC+UhSaxYwbHF92MJKQeA0mbboXgoszw1HM7oeSRWPf8gMPceBTQ5X2uanoaRb8L3HhHN70YJsap6k7/Ot0NMUlWCC7Xcya+jP4sfzDO04YnacfXPkRmrG1ww8Z8i1teN37owOL++7iUxcuz6Oo7Tk57HslWCYTcB+9z2v+8tp3Zs62DLEsmYkRPeJaUV+nndcWsOOXgjao4hAcNe6w8cpZ+JwcReteqLIKQ2hKzZyjb5Vi13mx37svGLvN
 DSf2HbFA
 jg4X4HB7ROa/SAdoIkma/y9sK+OrRZtPLVTpuNMcai1aRRwO2BWdXSRHBr2EeKXevf5xBYsZaRe2d0bHM4lGvX7ykxhpubZneoy+gqbLCt4KWRhfF+GLF3Mzg/Aw2OO7sHfmjOvtNmTVgfjF5Fh9ODRbWMgVK5eRDLJjdfDz+7wekvQaLFgHhV6fPIqbvz71jlQtr0lhdUS9W+SU4FaSGR2j0A1RYoqjxvXJpbXlHxbjeiK8iAWUWObvUoWkyNlcWLOJwZQkJw9kIVbhuGXzWGrDwWbHiDGKZcF38WrS5MQe572kq9fe+wvNc8EMeHUUpKHTeNsY5BkFtWoV6mf8rQ1soVMMe6ZnhIRejo8N2p8I4Gg7ccwk98mRdfk4CQyoZu4BkLj2HnxpCg61EQlf7kiYdHjjkLFhKqjg11E5UWCvTqkcM+bxQgpP5/1kCTdlzbDiRZN1JMWP4fCnyKL4i8InYwZ43EtBOid8A0kBvn9qKZeXc2XGKNIgkguuvzqXHhiZLrAJsZvF6IoT0hovsi84ST9PGoyEdR1X9AFh1gBobzpMgSVe2wlqdjZoPUkNqCItVnrOysSAKQuBWk8PkbMSleGDMitf4VzbfldnL/XGHK84uHONVJStY8rWUNz5PMgb385bQthmjkC8z9ToICTITrZoYL3dmUqFY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] proc: unguarded zero-length user copies in pde_ioctl_buf()
- [Low] proc: split declaration and initialization of __free() variable in =
pde_ioctl_buf()
--

commit 468d1faef733a0559be5a05e125e1ce20ec69e4e
Author: Christian Brauner <brauner@kernel.org>

proc: let procfs copy ioctl arguments in and out

This commit introduces ->proc_ioctl_buf() and ->proc_ioctl_args to allow
procfs to copy ioctl arguments from and to userspace outside of pinning the
proc_dir_entry, preventing page faults during user copies from blocking
remove_proc_entry().

> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index 3f29a1663d266..7e4ca5751abb5 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
[ ... ]
> @@ -571,11 +572,66 @@ static long pde_ioctl(struct proc_dir_entry *pde, s=
truct file *file, unsigned in
[ ... ]
> +static long pde_ioctl_buf(struct proc_dir_entry *pde, struct file *file,
> +			  unsigned int cmd, void __user *uarg, unsigned long arg)
> +{
> +	void *buf __free(kvfree) =3D NULL;
> +	struct proc_ioctl_arg a;
> +	size_t size;
> +	long rv;
> +
> +	if (!pde_ioctl_arg(pde, cmd, &a))
> +		return -ENOTTY;
> +	size =3D max(a.in, a.out);
> +	if (size) {
> +		buf =3D kvzalloc(size, GFP_KERNEL);

[Severity: Low]
This isn't a bug, but in pde_ioctl_buf() in fs/proc/inode.c, buf is declared
with __free(kvfree) =3D NULL at the top of the function and assigned later =
when
size is non-zero. Per the cleanup.h guidelines, could buf be defined and
initialized in a single statement once size is known (for example,
void *buf __free(kvfree) =3D size ? kvzalloc(size, GFP_KERNEL) : NULL;)?

> +		if (!buf)
> +			return -ENOMEM;
> +		if (copy_from_user(buf, uarg, a.in))
> +			return -EFAULT;
> +	}
> +
> +	if (!pde_pin(pde))
> +		return -ENOTTY;
> +	rv =3D pde->proc_ops->proc_ioctl_buf(file, cmd, buf ?: (void *)arg);
> +	pde_unpin(pde);
> +	if (rv >=3D 0 && copy_to_user(uarg, buf, a.out))
> +		return -EFAULT;

[Severity: Medium]
Should copy_from_user() and copy_to_user() in pde_ioctl_buf() in
fs/proc/inode.c be guarded by checking a.in and a.out respectively?

Because a.in and a.out are runtime values loaded from
proc_ops->proc_ioctl_args, check_copy_size() and _inline_copy_from_user() /
_inline_copy_to_user() do not short-circuit when the length is 0 and still
invoke raw_copy_from_user() / raw_copy_to_user().

When a command has a.out =3D=3D 0 (such as an _IOW or _IO command) and user=
space
passes arg =3D=3D 0, calling copy_to_user(NULL, buf, 0) fails with -EFAULT =
on
C-SKY after ->proc_ioctl_buf() has already succeeded, because C-SKY checks =
the
destination pointer for NULL before checking whether the length is 0:

arch/csky/lib/usercopy.c:raw_copy_to_user() {
	...
	"0:     cmpnei  %1, 0           \n"
	"       bf      8f              \n"
	...
}

On UML, calling copy_from_user() with a.in =3D=3D 0 or copy_to_user() with
a.out =3D=3D 0 still enters buffer_op() -> do_op_one_page() -> maybe_map() =
->
handle_page_fault() on uarg before checking if remain =3D=3D 0:

arch/um/kernel/skas/uaccess.c:buffer_op() {
	...
	size =3D min(PAGE_ALIGN(addr) - addr, (unsigned long) len);
	remain =3D len;

	n =3D do_op_one_page(addr, size, is_write, op, arg);
	if (n !=3D 0)
		return (n < 0 ? remain : 0);
	...
}

Additionally, when both a.in =3D=3D 0 and a.out =3D=3D 0, size is 0 and buf=
 remains
NULL, so copy_to_user(uarg, NULL, 0) passes a NULL source pointer into
raw_copy_to_user() (and memcpy() on CONFIG_UACCESS_MEMCPY or UML builds).

Would it make sense to check if (a.in && copy_from_user(buf, uarg, a.in)) a=
nd
if (rv >=3D 0 && a.out && copy_to_user(uarg, buf, a.out))?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-core-v1-0-75df35e4f8b8@kernel.org?part=3D15

