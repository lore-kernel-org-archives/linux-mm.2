Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3D3EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C67546B014F; Mon, 13 Jul 2026 12:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18376B0152; Mon, 13 Jul 2026 12:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2EBD6B0153; Mon, 13 Jul 2026 12:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85F4D6B014F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:52:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6F71F168C63
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:27:17 +0000 (UTC)
X-FDA: 84983980914.30.2495193
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.183])
	by imf01.hostedemail.com (Postfix) with ESMTP id 646F740009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:27:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=bFnjf3GZ;
	spf=pass (imf01.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.183 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783952835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iaLgv2BDveiB9cTDQA1hlKsSjdSyePkmq764Gt+8i9o=;
	b=Lk+5RWV+Uz+eEWVPwnsqkTfEDoMXIR4SsMyV6kABQ6v2mMVily/uLH58uMltuuDdB5ks49
	olbzSepmQuq8EY3s4JY7LBZxYUby7eQOAMGWbS3GutpN0cS4FMa1BDZhgMF4zyoB3AoOQq
	YyxwzaeLDGWhsO2fs/tRQLgKtzPCuIA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=bFnjf3GZ;
	spf=pass (imf01.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.183 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783952835;
	b=UNvVNwMZ+7wlsevJ6wGPjvtHjNhQS/kh2HhNxvBnQPB0mj3t463pGwR6eZ0ULo4Uzl+EEw
	+cmJ+YmiXu+Du18/lNnifzOwTaECz2Wo4VY6fWFBKR0QUU4Ev1tTTPl0gENKvkeMTx3YwI
	E2CURu1oUo+0ApR4gScZp1IOFumxaDY=
X-KPN-MessageId: f0cdd940-7ec6-11f1-8f54-005056992ed3
Received: from mta.kpnmail.nl (unknown [10.31.161.190])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id f0cdd940-7ec6-11f1-8f54-005056992ed3;
	Mon, 13 Jul 2026 16:27:13 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.190])
	by mta.kpnmail.nl (Halon) with ESMTP
	id f0cad273-7ec6-11f1-b307-0050569977a2;
	Mon, 13 Jul 2026 16:27:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=iaLgv2BDveiB9cTDQA1hlKsSjdSyePkmq764Gt+8i9o=;
	b=bFnjf3GZsDi4jaX0Yga/FoiycnY0KvMHcY7b3zcmxMu1yp4aAOVYsvBjgNxyfEALxLbCP/w61x2q1
	 FXv/VefpQt0Tg6FIB6iBqusW/4yhYGWMiKH4DlJb6mbGWvpp6WcfvANNVWs5066Ed1iVd40M4Hb/xj
	 qX+PcgjJPm6j0q4wQgI9pLxFZTEcfNWZBmX0rLxKFS5+fmFDi4nElwv/3GBtkfAsL+qGHM+X6gRkpy
	 tW2MhxSMZ1vy/7Z5KMpiWhdntEalBXtnnMNdn9LN63kternvYxwph6w2KCzk2rWKS6bgT6JG93Hz1K
	 gcIIHtB6FTSIG/Ajkn/6tAopCGtel4w==
X-KPN-MID: 33|qsuEQdNEvuBFtwNk6ROruy+2Y66UI1YowGqXh3sB8ITQXHEKkfDqFoZq6C7U0wp
 ZHv0edVJqpLD2k5CjKAKM/pxiQOxwcHg2o6whg2OIDXE=
X-CMASSUN: 33|DKpEomnx7w/OtmUBXF1IrZfKmSs9bQZtxdkKUN35bE7va/CfAKBEMSFCM/wu/BZ
 Ir3r8nWsNq1pvgX/egS4yNA==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh01 (cpxoxapps-mh01.personalcloud.so.kpn.org [10.128.135.207])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id f0bbb2c8-7ec6-11f1-916a-005056995d6c;
	Mon, 13 Jul 2026 16:27:13 +0200 (CEST)
Date: Mon, 13 Jul 2026 16:27:13 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Message-ID: <299644823.863357.1783952833258@kpc.webmail.kpnmail.nl>
Subject: Re: [PATCH v3 09/24] binfmt_misc: rename Node to struct
 binfmt_misc_entry
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Originating-IP: 178.229.242.209
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 646F740009
X-Stat-Signature: 9su15iwa41mcoekkzd77y8uzc8ih8tsi
X-HE-Tag: 1783952835-915381
X-HE-Meta: U2FsdGVkX19qwUh2bq+fEvGC+AFzTiWf8Vqf2p/ylUZEC00n77bF6lhIQsEb1BPzWk2E+VodMwqDFI0/NIGsGvskDF6q9LeLdrrOi2LQBDYMtRyLfbwXLxnv3pqefvrVPpTWODhKZTmeg3Pef9mssr+o9BeSZgcTt6Fdagh5dba5hateJkQkpP2LvdW3+/WFjNfIV9uC4lB7crz/JilPZ6RPEWHb1UzOPdzXu77ba/0iF14Ga7dblyhrFVfKmt5tdIWlWzvKvF3W1E2V6bqsRaGd5xYysnFKAq+hph3XNNDMkOSsAyyyo0NpmrjhkmRgvZVguGriZYmFAA6bBu7k6s0+x+Jj7OFNm+OOK7p8Ei3Kkeeg+IXfUdf7SEaX07oNiU17hKo5byS20Qx9jb1cAoMv3r3MyBoZtBGZqa7UffePk+GeGKdyhZ5wj5RuYFhZcGCFlmO6rJWZU7D57g/Y1vnGLHA52efvk+xmpoJrzAo9cCNBKFxzh9SDlgc9+Wb/e7Hj0JzLHCnwrEFXz3ANJOLAXxv0jaFtsdrowuMZzKwp9+HGbt8H0bZbjRBb2qCVUnvNUnhHLcSZ3kIQn0m/155s9Meb6tK5VMMUj369v8h0YrOE0dy5ZBUzWb0v+j47o0ZQpqYBV7OrhxNw0guslVp3iNAY5f/dnMuXI79O1XeuRpr8BVrRtuW1vU3VxpQnMQhxvAHFH7IbDMSoCbMF/BXv65HcpkrE18mIBKGwXHYkYikjHA4FxOGYTKFpO60YkDwlEGK5XmZ7Y3sKt/3VKDBZimK44E/CJ1HCGxrvdKYNVJFZBAeKqa1PlvfMnN5nlfNZTzCQUcr3tDI8Q4C9HSELbM7cOCM5ylA3qgVQiFBIdHEnY+QOCxio07BPI3t6LnFY0eWVj3aaJvPv0E/1nq16jCx761t0gmpTdpz+VFZyQ+vujLK67YpGT8i8GM/3o9uqI/EdAvRqVzIwM5c
 XJiIM4je
 eTyLOpJlf4UYbU1KoHbD0EbTt2KBhj2xP/bu/AT12FeZUfHmQnryEuDZTYeD8X5rm2HHb0pX0YPRPxuicy3UjycIo3zmmo3KeryGq+zCU248j8httH6r/yVr9JIe/cMLNAyoyVj65eslMo3nRaWhAn7R4TREQrnfSu14kGxEtbNaoO4RqxT1zFeu8xCIhLebCvnpV1kfm06hhWXOtNCu8sHcd7rrETceVNyBr38Yonp1tzUlpaCZPtqLwFmDHxpWJA9sOAbc0IbwjdbwVG5AwG0qicPmzRiGX1bTfB8RfPxZsdEwC7+vl4Dk8ndnhJYXtfDeIPshsmYMy7EiTpDMxDd4kHmPWqnV9Q7j+tF6mIVVGIeHcBCuGE//774ZhsImWo7VfWI5OmIqMuf0si1AbklL0lt0OTOmy5hHLIpixp3mGPInhARyWyohIIqyibQk6Dtpq1CYPcJ1ws5VwU+6s6XqRse5jaUC0Uz6DpYd+y1ynJ7pUDBXvN91vJ8mqQ8AQ+4dsALZbg+23tJ43X6VHV/aImkag78lou1WIro/wKU6Rm5INgNqkhzmerxQHPlrKCRy69OYK9fYV+GM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:10AM +0200, Christian Brauner wrote:
> The CamelCase Node typedef is a 1997 leftover and hides that this is
> a plain struct. Call it what it is: struct binfmt_misc_entry, matching
> struct binfmt_misc that it hangs off of and the entry bit and flag
> enums. Drop the typedef, switch the size computations in
> create_entry() to sizeof(*e) and adjust the comments that still
> referred to the old name.
> 
> No functional change.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 60 +++++++++++++++++++++++++++++---------------------------
>  1 file changed, 31 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 98ad1383ba6b..9be57f387524 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -56,7 +56,7 @@ enum binfmt_misc_entry_flags {
>  	MISC_FMT_OPEN_FILE	= (1U << 28),
>  };
>  
> -typedef struct {
> +struct binfmt_misc_entry {
>  	struct hlist_node node;
>  	unsigned long flags;		/* type, status, etc. */
>  	int offset;			/* offset of magic */
> @@ -69,7 +69,7 @@ typedef struct {
>  	struct file *interp_file;
>  	refcount_t users;		/* sync removal with load_misc_binary() */
>  	struct rcu_head rcu;
> -} Node;
> +};
>  
>  static struct file_system_type bm_fs_type;
>  
> @@ -84,7 +84,7 @@ static struct file_system_type bm_fs_type;
>   *  - interp: ~50 bytes
>   *  - flags:  5 bytes
>   * Round that up a bit, and then back off to hold the internal data
> - * (like struct Node).
> + * (like struct binfmt_misc_entry).
>   */
>  #define MAX_REGISTER_LENGTH 1920
>  
> @@ -100,11 +100,11 @@ static struct file_system_type bm_fs_type;
>   *
>   * Return: binary type list entry on success, NULL on failure
>   */
> -static Node *search_binfmt_handler(struct binfmt_misc *misc,
> -				   struct linux_binprm *bprm)
> +static struct binfmt_misc_entry *
> +search_binfmt_handler(struct binfmt_misc *misc, struct linux_binprm *bprm)
>  {
>  	char *p = strrchr(bprm->interp, '.');
> -	Node *e;
> +	struct binfmt_misc_entry *e;
>  
>  	/* Walk all the registered handlers. */
>  	hlist_for_each_entry_rcu(e, &misc->entries, node) {
> @@ -153,10 +153,10 @@ static Node *search_binfmt_handler(struct binfmt_misc *misc,
>   *
>   * Return: binary type list entry on success, NULL on failure
>   */
> -static Node *get_binfmt_handler(struct binfmt_misc *misc,
> -				struct linux_binprm *bprm)
> +static struct binfmt_misc_entry *get_binfmt_handler(struct binfmt_misc *misc,
> +						    struct linux_binprm *bprm)
>  {
> -	Node *e;
> +	struct binfmt_misc_entry *e;
>  
>  	guard(rcu)();
>  	do {
> @@ -166,14 +166,14 @@ static Node *get_binfmt_handler(struct binfmt_misc *misc,
>  }
>  
>  /**
> - * put_binfmt_handler - put binary handler node
> - * @e: node to put
> + * put_binfmt_handler - put binary handler entry
> + * @e: entry to put
>   *
> - * Free node syncing with load_misc_binary() and defer final free to
> + * Free entry syncing with load_misc_binary() and defer final free to
>   * load_misc_binary() in case it is using the binary type handler we were
>   * requested to remove.
>   */
> -static void put_binfmt_handler(Node *e)
> +static void put_binfmt_handler(struct binfmt_misc_entry *e)
>  {
>  	if (refcount_dec_and_test(&e->users)) {
>  		if (e->flags & MISC_FMT_OPEN_FILE) {
> @@ -219,7 +219,7 @@ static struct binfmt_misc *load_binfmt_misc(void)
>   */
>  static int load_misc_binary(struct linux_binprm *bprm)
>  {
> -	Node *fmt;
> +	struct binfmt_misc_entry *fmt;
>  	struct file *interp_file = NULL;
>  	int retval = -ENOEXEC;
>  	struct binfmt_misc *misc;
> @@ -290,7 +290,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
>  ret:
>  
>  	/*
> -	 * If we actually put the node here all concurrent calls to
> +	 * If we actually put the entry here all concurrent calls to
>  	 * load_misc_binary() will have finished. We also know
>  	 * that for the refcount to be zero someone must have concurently
>  	 * removed the binary type handler from the list and it's our job to
> @@ -326,7 +326,7 @@ static char *scanarg(char *s, char del)
>  	return s;
>  }
>  
> -static char *check_special_flags(char *sfs, Node *e)
> +static char *check_special_flags(char *sfs, struct binfmt_misc_entry *e)
>  {
>  	char *p = sfs;
>  	int cont = 1;
> @@ -370,9 +370,10 @@ static char *check_special_flags(char *sfs, Node *e)
>   * ':name:type:offset:magic:mask:interpreter:flags'
>   * where the ':' is the IFS, that can be chosen with the first char
>   */
> -static Node *create_entry(const char __user *buffer, size_t count)
> +static struct binfmt_misc_entry *create_entry(const char __user *buffer,
> +					      size_t count)
>  {
> -	Node *e;
> +	struct binfmt_misc_entry *e;
>  	int memsize, err;
>  	char *buf, *p;
>  	char del;
> @@ -385,14 +386,14 @@ static Node *create_entry(const char __user *buffer, size_t count)
>  		goto out;
>  
>  	err = -ENOMEM;
> -	memsize = sizeof(Node) + count + 8;
> +	memsize = sizeof(*e) + count + 8;
>  	e = kmalloc(memsize, GFP_KERNEL_ACCOUNT);
>  	if (!e)
>  		goto out;
>  
> -	p = buf = (char *)e + sizeof(Node);
> +	p = buf = (char *)e + sizeof(*e);
>  
> -	memset(e, 0, sizeof(Node));
> +	memset(e, 0, sizeof(*e));
>  	if (copy_from_user(buf, buffer, count))
>  		goto efault;
>  
> @@ -602,7 +603,7 @@ static int parse_command(const char __user *buffer, size_t count)
>  
>  /* generic stuff */
>  
> -static void entry_status(Node *e, char *page)
> +static void entry_status(struct binfmt_misc_entry *e, char *page)
>  {
>  	char *dp = page;
>  	const char *status = "disabled";
> @@ -686,7 +687,7 @@ static struct binfmt_misc *i_binfmt_misc(struct inode *inode)
>  */
>  static void bm_evict_inode(struct inode *inode)
>  {
> -	Node *e = inode->i_private;
> +	struct binfmt_misc_entry *e = inode->i_private;
>  
>  	clear_inode(inode);
>  
> @@ -714,7 +715,8 @@ static void bm_evict_inode(struct inode *inode)
>   * to use writes to files in order to delete binary type handlers. But it has
>   * worked for so long that it's not a pressing issue.
>   */
> -static void remove_binfmt_handler(struct binfmt_misc *misc, Node *e)
> +static void remove_binfmt_handler(struct binfmt_misc *misc,
> +				  struct binfmt_misc_entry *e)
>  {
>  	spin_lock(&misc->entries_lock);
>  	hlist_del_init_rcu(&e->node);
> @@ -727,7 +729,7 @@ static void remove_binfmt_handler(struct binfmt_misc *misc, Node *e)
>  static ssize_t
>  bm_entry_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
>  {
> -	Node *e = file_inode(file)->i_private;
> +	struct binfmt_misc_entry *e = file_inode(file)->i_private;
>  	ssize_t res;
>  	char *page;
>  
> @@ -747,7 +749,7 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
>  				size_t count, loff_t *ppos)
>  {
>  	struct inode *inode = file_inode(file);
> -	Node *e = inode->i_private;
> +	struct binfmt_misc_entry *e = inode->i_private;
>  	int res = parse_command(buffer, count);
>  
>  	switch (res) {
> @@ -796,7 +798,7 @@ static const struct file_operations bm_entry_operations = {
>  /* /register */
>  
>  /* add to filesystem */
> -static int add_entry(Node *e, struct super_block *sb)
> +static int add_entry(struct binfmt_misc_entry *e, struct super_block *sb)
>  {
>  	struct dentry *dentry = simple_start_creating(sb->s_root, e->name);
>  	struct inode *inode;
> @@ -828,7 +830,7 @@ static int add_entry(Node *e, struct super_block *sb)
>  static ssize_t bm_register_write(struct file *file, const char __user *buffer,
>  			       size_t count, loff_t *ppos)
>  {
> -	Node *e;
> +	struct binfmt_misc_entry *e;
>  	struct super_block *sb = file_inode(file)->i_sb;
>  	int err = 0;
>  	struct file *f = NULL;
> @@ -894,7 +896,7 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
>  	int res = parse_command(buffer, count);
>  	struct hlist_node *next;
>  	struct inode *inode;
> -	Node *e;
> +	struct binfmt_misc_entry *e;
>  
>  	misc = i_binfmt_misc(file_inode(file));
>  	switch (res) {
> 
> -- 
> 2.53.0
> 

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

